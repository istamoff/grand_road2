import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unikids_uz/model/parents/parents_model.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab2/add/bloc/parents_add_bloc.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab2/add/parents_add_screen.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab2/update/parents_update_screen.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab2/bloc/parents_main_bloc.dart';
import 'package:unikids_uz/utils/styles.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:unikids_uz/widgets/delete_dialog.dart';



class ParentsMainScreen extends StatefulWidget {

  final int id;

  static Widget screen(id) => BlocProvider(
        create: (context) => ParentsMainBloc(),
        child: ParentsMainScreen(id: id),
      );

  ParentsMainScreen({required this.id});


  @override
  _ParentsMainScreenState createState() => _ParentsMainScreenState();
}

class _ParentsMainScreenState extends State<ParentsMainScreen> {
  late ParentsMainBloc bloc;
  final ScrollController _pageNationController = ScrollController();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late bool isConnect;
  late double wSize;
  double imageW = 90;
  double imageH = 140;


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
    bloc = BlocProvider.of<ParentsMainBloc>(context);
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

  _showToast(Color color, String txt){
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  @override
  Widget build(BuildContext context) {
    wSize = MediaQuery.of(context).size.width;
    return
      BlocConsumer<ParentsMainBloc, ParentsMainState>(
      listener: (context, state) {
        if(state is DeleteLoaded) {
          _showToast(Colors.green, MyWords.success_delete.tr());
          Navigator.pop(context);
          print("Loaded delete");
        }
      },
      builder: (context, state) {
        return BlocBuilder<ParentsMainBloc, ParentsMainState>(
          builder: (context, state) {
            if (state is ParentsMainError) {
              return Container(height: double.infinity, width: double.infinity,
                  child: Center(child: Text(state.error, style: MyStyles.White18)));
            }
            if(state is ParentsMainNoInfo) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: Center(child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(MyColors.baseOrangeColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ParentsAddScreen.screen(widget.id))).then((value){
                        Navigator.pop(context);
                        bloc.add(HistoryEvent(isConnect: isConnect, id: widget.id));
                      });
                    },
                    child: Text(MyWords.parents_add.tr(), style: TextStyle(color: Colors.white, fontSize: 18)))),
              );
            }
            if(state is ParentsMainLoaded) {
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
            if(state is DeleteLoaded) {
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
                            return _listItemWidget(state.model.results[index]);           // _listItemWidget(state.model.results[index]);
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
            if (state is ParentsMainInitial || state is ParentsMainLoading) {
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: (){
        _showBottomDialog(result);
      },
      onLongPress: (){
        _showBottomDialog(result);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 12, right: 12),
        child: Column(
          children: [
           SizedBox(
              height: imageH,
              child: Row(
                children: [
                  result.photo == "" ?
                  SizedBox(
                      width: imageW,
                      height: imageH,
                      child: Image.asset('assets/image/no_image.png'))
                      :            SizedBox(
                    width: imageW,
                    height: imageH,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: result.photo,
                      imageBuilder: (context, imageProvider) => Container(
                        width: imageW,
                        height: imageH,
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
                            fit: BoxFit.contain,
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Spacer(),
                              Text(result.firstName, style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black)),
                              Text(result.middleName, style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black)),
                              Text(result.lastName, style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black)),
                              Spacer(),
                            ],
                          ),
                        ),
                         Expanded(
                           child: Column(
                             children: [
                               Spacer(),
                               Container(
                                child: Expanded(child: ListView.separated(
                                      itemCount: result.contacts.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 4);
                                      },
                                      itemBuilder: (BuildContext context, int index) {
                                        return Text(result.contacts[index], style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black));
                                      }
                                  )),
                               ),
                               Spacer(),
                             ],
                           ),
                         ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: MyColors.baseOrangeColor, thickness: 1)
          ],
        ),
      ),
    );
  }


  void _showBottomDialog(Result result) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 180,
        width: double.infinity,
        child: Column(
          children: [
            ListTile(
                leading: Icon(Icons.edit, color: Colors.grey,),
                title: Text(MyWords.edit.tr(), style: MyStyles.grey,),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ParentsUpdateScreen.screen(result.id))).then((value){
                    Navigator.pop(context);
                    bloc.add(HistoryEvent(isConnect: isConnect, id: widget.id));
                  });
                }),
            ListTile(
                leading: Icon(Icons.delete, color: Colors.grey,),
                title: Text(MyWords.delete.tr(), style: MyStyles.grey),
                onTap: () {
                 DialogUtils.onDeleteDialog(context, bloc, result.id,  widget.id);
                }),
            ListTile(
                leading: Icon(Icons.add, color: Colors.grey),
                title: Text(MyWords.add_btn.tr(), style: MyStyles.grey),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ParentsAddScreen.screen(widget.id))).then((value){
                    Navigator.pop(context);
                    bloc.add(HistoryEvent(isConnect: isConnect, id: widget.id));
                  });
                }),
          ],
        ),
      ),
    );
  }


}
