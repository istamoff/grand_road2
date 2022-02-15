import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unikids_uz/model/teacher_go_out_model.dart';
import 'package:unikids_uz/screens/main/tab/teacher/go_out/bloc/goout_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/styles.dart';
import 'package:unikids_uz/utils/words.dart';

class GoOutScreen extends StatefulWidget {

  static Widget screen() =>
      BlocProvider(
        create: (context) => GooutBloc(),
        child: GoOutScreen(),
      );
  
  @override
  _GoOutScreenState createState() => _GoOutScreenState();
}

class _GoOutScreenState extends State<GoOutScreen> {
  late GooutBloc bloc;
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
    bloc = BlocProvider.of<GooutBloc>(context);
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
        bloc.add(NextEvent());
    }
    if (_pageNationController.offset <=
        _pageNationController.position.minScrollExtent &&
        !_pageNationController.position.outOfRange) {
        }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GooutBloc, GooutState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return BlocBuilder<GooutBloc, GooutState>(
          builder: (context, state) {
            if (state is GooutUnDefinedError)
              return Container(height: double.infinity, width: double.infinity,
                  child: Center(child: Text(MyWords.undefiend_error.tr(), style: MyStyles.White18,)));
           if(state is GooutServerError)
             return Container(height: double.infinity, width: double.infinity,
                 child: Center(child: Text(MyWords.server_error.tr(), style: MyStyles.White18,)));
            if(state is GooutNoInformation)
              return Center(child: Text(MyWords.no_info.tr(), style: TextStyle(color: MyColors.baseWhiteColor, fontSize: 18)));
            if(state is GooutLoaded) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: _pageNationController,
                  itemCount: state.model.results.length,
                  // separatorBuilder: (BuildContext context, int index) =>
                  // SizedBox(height: 16),
                  itemBuilder: (BuildContext context, int index) {
                    return _listItemWidget(state.model.results[index]);
                  }
              );
            }
            if(state is BottomLoading) {
              return
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
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
                        color: MyColors.baseOrangeColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: CircularProgressIndicator(
                          color: MyColors.baseLightColor)),
                    ),
                  ],
                );
            }
            if (state is GooutInitial || state is GooutLoading)
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator(
                    color: MyColors.baseLightColor)),
              );
            return SizedBox();
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: MyColors.baseOrangeColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: CircularProgressIndicator(
                color: MyColors.baseLightColor)),
          ),
        );
      },
    );
  }

  Widget _listItemWidget(Result result) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Row(
            children: [
              result.child.photo == "" ?
              SizedBox(
                  width: 76,
                  height: 98,
                  child: Image.asset('assets/image/no_image.png'))
                  :            SizedBox(
                width: 76,
                height: 98,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: result.child.photo,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 76,
                    height: 98,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 4, color: MyColors.baseWhiteColor),
                      boxShadow: const [
                        BoxShadow(
                            color: MyColors.baseWeightShadowColor,
                            blurRadius: 4,
                            spreadRadius: 0.25),
                      ],
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
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              //   ),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                            color: MyColors.baseWhiteColor)),
                  ),
                  SizedBox(height: 8),
                  Text(result.goOutTime.toString().toUpperCase().substring(11, 16),
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                  SizedBox(height: 8),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(color: MyColors.baseLightColor, thickness: 2)
        ],
      ),
    );
  }
}
