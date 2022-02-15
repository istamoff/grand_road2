import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unikids_uz/model/lang_status_model.dart';
import 'package:unikids_uz/model/nurse_model.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/main/tab/nurse/bloc/nurse_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/styles.dart';
import 'package:connectivity/connectivity.dart';
import 'package:unikids_uz/utils/words.dart';


class NurseScreen extends StatefulWidget {
  static Widget screen() =>
      BlocProvider(
        create: (context) => NurseBloc(),
        child: NurseScreen(),
      );

  @override
  _NurseScreenState createState() => _NurseScreenState();
}

class _NurseScreenState extends State<NurseScreen> {
  late NurseBloc bloc;
  final ScrollController _pageNationController = ScrollController();


  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late bool isConnect;


  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        isConnect = true;
        bloc.add(HistoryEvent(isConnect: isConnect));
        break;
      case ConnectivityResult.mobile:
        isConnect = true;
        bloc.add(HistoryEvent(isConnect: isConnect));
        break;
      case ConnectivityResult.none:
        isConnect = false;
        bloc.add(HistoryEvent(isConnect: isConnect));
        break;
      default:
        isConnect = false;
        bloc.add(HistoryEvent(isConnect: isConnect));
        break;
    }
  }

  @override
  void initState() {
    bloc = BlocProvider.of<NurseBloc>(context);
    _registerBus();
    _pageNationController.addListener(() => _scrollListener());
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }


  @override
  void dispose() {
    _pageNationController.dispose();
    _connectivitySubscription.cancel();
    bloc.close();
    super.dispose();
  }

  _scrollListener() {
    if (_pageNationController.offset >=
        _pageNationController.position.maxScrollExtent &&
        !_pageNationController.position.outOfRange) {
      print("If _scrollListener");
        bloc.add(NextEvent());
    }
    if (_pageNationController.offset <=
        _pageNationController.position.minScrollExtent &&
        !_pageNationController.position.outOfRange) {
      print("Else _scrollListener");
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NurseBloc, NurseState>(
      listener: (context, state) {
        if(state is NurseNoInfo)
        print("nurseNoInfo");
        if(state is NurseError)
          print("nurseErrorInfo");
      },
      builder: (context, state) {
        return BlocBuilder<NurseBloc, NurseState>(
          builder: (context, state) {
            if(state is NurseLoaded) {
              return Container(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    controller: _pageNationController,
                    itemCount: state.model.results.length,
                    // separatorBuilder: (BuildContext context, int index) =>
                    // SizedBox(height: 16),
                    itemBuilder: (BuildContext context, int index) {
                      return _listItemWidget(state.model.results[index]);
                    }
                ),
              );
            }
            if(state is BottomLoading) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        controller: _pageNationController,
                        itemCount: state.model.results.length,
                        // separatorBuilder: (BuildContext context, int index) =>
                        // SizedBox(height: 16),
                        itemBuilder: (BuildContext context, int index) {
                          return _listItemWidget(state.model.results[index]);
                        }
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.yellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: const CircularProgressIndicator(
                        color: MyColors.yellow)),
                  ),
                ],
              );
            }
            if(state is NurseNoInfo){
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(MyWords.no_info.tr(), style: MyStyles.White18),
                ),
              );
            }
            if (state is NurseInitial || state is NurseLoading) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: const Center(child: const CircularProgressIndicator(
                    color: MyColors.secondaryColor)),
              );
            }
            if (state is NurseError) {
               return Container(
                 width: double.infinity,
                 height: double.infinity,
                 child: Center(
                   child: Text(MyWords.undefiend_error.tr(), style: MyStyles.White18),
                 ),
               );
            }
            if(state is NurseServerError) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(MyWords.server_error.tr(), style: MyStyles.White18),
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: MyColors.baseOrangeColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CircularProgressIndicator(
                color: MyColors.baseLightColor)),
          ),
        );
      },
    );
  }

  Widget _listItemWidget(Result result) {
    Color statusColor;
    if(result.status.color.toUpperCase() == "danger".toUpperCase())
        statusColor = Colors.red;

    else if(result.status.color.toUpperCase() == "warning".toUpperCase())
      statusColor = Colors.yellow;
    else
      statusColor = Colors.green;

    return Column(
      children: [
        Row(
          children: [
              result.child.photo == "" ?
              SizedBox(
                  width: 76,
                  height: 98,
                  child: Image.asset('assets/image/no_image.png'))
                    :
              SizedBox(
                  width: 76,
                  height: 98,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                          imageUrl: result.child.photo,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 76,
                            height: 98,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 4, color: MyColors.secondaryColor),
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //       color: MyColors.baseWeightShadowColor,
                                  //       blurRadius: 4,
                                  //       spreadRadius: 0.25),
                                  // ],
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                    ),
         //   ),

            const SizedBox(width: 8),
            Expanded(
              child: Container(
                child: Column(
                 // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MyContants.TEXTHEIGHT,
                      width: MyContants.TEXTWIDHT,
                      child: Text(
                          result.child.firstName.toUpperCase() + " " + result.child.lastName.toUpperCase() + " " + result.child.middleName.toUpperCase(),
                          maxLines: 3,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                              fontSize: 18,
                              color: MyColors.secondaryColor)),
                    ),
                    const SizedBox(height: 8),
                     Row(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(result.comeInTime.toString().toUpperCase().substring(11, 16),
                                    style: const TextStyle(fontSize: 16, color: MyColors.secondaryColor)),
                                //   Expanded(child: SizedBox()),
                                const SizedBox(height: 8),
                                Text(result.status.title.toString(),
                                    style: const TextStyle(fontSize: 16, color:Colors.black, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(result.temperature.toString(),
                              style: const TextStyle(fontSize: 32, color: MyColors.secondaryColor, fontWeight: FontWeight.bold)),
                        ],
                      ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: MyColors.primaryColor, thickness: 2)
      ],
    );
  }

  Future<void> _registerBus() async {
    bool isConnect = await checkInternetConnection();
    RxBus.register<LangStatusModel>(tag: "EVENT_LANG").listen(
          (event) {
          if(!isConnect){
            Fluttertoast.showToast(
                msg: MyWords.no_internet_connection.tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          else {
            if(event.lang == "uz" || event.lang == "ru")
            bloc.add(HistoryEvent(isConnect: isConnect));
          }
      },
    );
  }

  checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }



}
