import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab1/bloc/child_info_tab1_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/styles.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/model/child/child_in_out_model.dart';

class ChildInfoTab1 extends StatefulWidget {

  final int id;

  static Widget screen(id) =>
      BlocProvider(
        create: (context) => ChildInfoTab1Bloc(),
        child: ChildInfoTab1(id: id),
      );

  ChildInfoTab1({required this.id});


  @override
  _ChildInfoTab1State createState() => _ChildInfoTab1State();
}

class _ChildInfoTab1State extends State<ChildInfoTab1> {
  late ChildInfoTab1Bloc bloc;
  final ScrollController _pageNationController = ScrollController();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late bool isConnect;
  late double wSize;
  double imageW = 60;


  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        isConnect = true;
        bloc.add(HistoryEvent(isConnect: isConnect, id: widget.id));
        break;
      case ConnectivityResult.mobile:
        isConnect = true;
        bloc.add(HistoryEvent(isConnect: isConnect, id: widget.id));
        break;
      case ConnectivityResult.none:
        isConnect = false;
        bloc.add(HistoryEvent(isConnect: isConnect, id: widget.id));
        break;
      default:
        isConnect = false;
        bloc.add(HistoryEvent(isConnect: isConnect, id: widget.id));
        break;
    }
  }

  @override
  void initState() {
    bloc = BlocProvider.of<ChildInfoTab1Bloc>(context);
    //   bloc.add(HistoryEvent());
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
    wSize = MediaQuery.of(context).size.width;
    return BlocConsumer<ChildInfoTab1Bloc, ChildInfoTab1State>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return BlocBuilder<ChildInfoTab1Bloc, ChildInfoTab1State>(
          builder: (context, state) {
            if (state is ChildInfoTab1Error) {
              return Container(height: double.infinity, width: double.infinity,
                  child: Center(child: Text(state.error, style: MyStyles.White18)));
            }
            if(state is ChildInfoTab1NoInfo)
             return Center(child: Text(MyWords.no_info.tr(), style: TextStyle(color: Colors.black, fontSize: 18)));
            if(state is ChildInfoTab1Loaded) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: _pageNationController,
                  itemCount: state.model.results.length,
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
                      child: Center(child: const CircularProgressIndicator(
                          color: MyColors.baseLightColor)),
                    ),
                  ],
                );
            }
            if (state is ChildInfoTab1Initial || state is ChildInfoTab1Loading) {
              return Container(
                child: Center(child: CircularProgressIndicator(
                    color: MyColors.baseLightColor)),
              );
            }
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: MyColors.baseOrangeColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: const CircularProgressIndicator(
                color: MyColors.baseLightColor)),
          ),
        );
      },
    );
  }

  Widget _listItemWidget(Result result) {
    bool isComeIn = false;
    bool isGoOut = false;

    print("TIME " + result.comeInTime.toString());
    late int inDay, inMouth, inHour, inMin;
    late int outDay, outMouth, outHour, outMin;
    if(result.comeInTime != DateTime(0)) {
     inDay = result.comeInTime.day;
     inMouth = result.comeInTime.month;
     inHour = result.comeInTime.hour;
     inMin = result.comeInTime.minute;
     isComeIn = true;
    }
   if(result.goOutTime != DateTime(0)){
     outDay = result.comeInTime.day;
     outMouth = result.comeInTime.month;
     outHour = result.comeInTime.hour;
     outMin = result.comeInTime.minute;
     isGoOut = true;
   }

    return Container(
      child: Column(
        children: [
         isComeIn ? SizedBox(
            height: 100,
            child: Row(
              children: [
                result.receivePhoto == "" ?
                SizedBox(
                    width: imageW,
                    height: 75,
                    child: Image.asset('assets/image/no_image.png'))
                    :            SizedBox(
                  width: imageW,
                  height: 75,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: result.receivePhoto,
                    imageBuilder: (context, imageProvider) => Container(
                      width: imageW,
                      height: 75,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(width: 4, color: MyColors.baseWhiteColor),
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                //   ),
                SizedBox(width: 8),
                result.comeInPerson.photo == "" ?
                SizedBox(
                    width: imageW,
                    height: 75,
                    child: Image.asset('assets/image/no_image.png'))
                    :            SizedBox(
                  width: imageW,
                  height: 75,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: result.comeInPerson.photo,
                    imageBuilder: (context, imageProvider) => Container(
                      width: imageW,
                      height: 75,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(width: 4, color: MyColors.baseWhiteColor),
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 150,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: wSize - 180,
                              child: AutoSizeText(
                                  result.comeInPerson.fullName,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black)),
                            ),
                            Spacer(),
                            isComeIn ? Text(
                                inHour.toString() + ":" + inMin.toString() + "\n" +
                                    inDay.toString() + "/" + inMouth.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14, color: Colors.grey)) : SizedBox(),
                          ],
                        ),
                      Icon(
                          Icons.arrow_upward_outlined,
                          size: 20,
                          color: Colors.red),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ) : SizedBox(),
          isGoOut ? SizedBox(
            height: 100,
            child: Row(
              children: [
                result.sendPhoto == "" ?
                SizedBox(
                    width: imageW,
                    height: 75,
                    child: Image.asset('assets/image/no_image.png'))
                    :   SizedBox(
                  width: imageW,
                  height: 75,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: result.sendPhoto,
                    imageBuilder: (context, imageProvider) => Container(
                      width: imageW,
                      height: 75,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(width: 4, color: MyColors.baseWhiteColor),
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                //   ),
                SizedBox(width: 8),
                result.goOutPerson.photo == "" ?
                SizedBox(
                    width: imageW,
                    height: 75,
                    child: Image.asset('assets/image/no_image.png'))
                    :            SizedBox(
                  width: imageW,
                  height: 75,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: result.goOutPerson.photo,
                    imageBuilder: (context, imageProvider) => Container(
                      width: imageW,
                      height: 75,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(width: 4, color: MyColors.baseWhiteColor),
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 150,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: wSize - 180,
                              child: AutoSizeText(
                                  result.goOutPerson.fullName,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black)),
                            ),
                            Spacer(),
                            isGoOut ? Text(
                                inHour.toString() + ":" + inMin.toString() + "\n" +
                                    inDay.toString() + "/" + inMouth.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 14, color: Colors.grey)) : SizedBox(),
                          ],
                        ),
                        Icon(Icons.arrow_downward_outlined,
                            size: 20,
                            color: Colors.green),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ) : SizedBox(),
          SizedBox(height: 4),
          Divider(color: MyColors.baseOrangeColor, thickness: 1)
        ],
      ),
    );
  }
}
