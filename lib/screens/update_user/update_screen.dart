import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/update_pupil/child_class_model.dart';
import 'package:unikids_uz/model/update_pupil/child_group_short_list_model.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/camera/camera_screen.dart';
import 'package:unikids_uz/screens/child/info/main/child_info_main_screen.dart';
import 'package:unikids_uz/screens/child/update/update_child_screen.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/styles.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/widgets/item_widget.dart';
import 'package:unikids_uz/model/update_pupil/all_pupil_model.dart';

import 'user_logged_in_event.dart';

class UpdateScreen extends StatefulWidget {
  final CameraDescription cameraDescription;
  final String token;

  UpdateScreen({required this.cameraDescription, required this.token});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  String _groupValue = "";
  late int _chosenClass = 0;
  late int _groupClass = 0;
  String _chosenValue = "";
  late String _nextUrl;

  final MyService _service = locator.get<MyService>();
  late ChildGroupModel _groupModel;
  late ChildClassModel _classModel;
  late AllPupilModel _pupilModel;
  late String _token;
  ScrollController _controller = ScrollController();
  bool isError = false;
  double WSize = 0;
  //
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  bool _filterLoading = false;

  Future _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      await _getClass();
      await _getGroup(0);
      _pupilModel =
          await _service.getAllPupil(_token, _chosenClass, _groupClass);
      // for(int i = 0; i < _pupilModel.results.length; i++){
      //   print(_pupilModel.results[i].id);
      // }
      _nextUrl = _pupilModel.next;
      setState(() {});
    } catch (err) {
      isError = true;
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future _filterLoad() async {
    setState(() {
      _filterLoading = true;
    });
    try {
      _pupilModel =
          await _service.getAllPupil(_token, _chosenClass, _groupClass);
      _nextUrl = _pupilModel.next;
      setState(() {});
    } catch (err) {
    }

    setState(() {
      _filterLoading = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _filterLoading == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      }); // Increase _page by 1
      try {
        final AllPupilModel model =
            await _service.getNextAllPupil(_token, _nextUrl);
        if (model.results.length > 0) {
          setState(() {
            _pupilModel.results.addAll(model.results);
            _nextUrl = model.next;
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    _token = widget.token;
    _registerBus();
    _groupValue = MyWords.all_group.tr();
    _chosenValue = MyWords.all_class.tr();
    _firstLoad();
    _controller.addListener(() => _loadMore());
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    RxBus.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WSize =  (MediaQuery.of(context).size.width - 95) / 2;
    print(MediaQuery.of(context).size.width.toString() + " WSIZE " + WSize.toString());
    return  _isFirstLoadRunning
          ? _centerLoading()
          : (isError ? Container(
                height: double.infinity,
                width: double.infinity,
                child: Text(MyWords.server_error.tr()),
    ) : _filterLoading
              ? Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      _filterWidget(_classModel, _groupModel),
                      _centerFilterLoading()
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      _filterWidget(_classModel, _groupModel),
                      SizedBox(height: 16),
                      _listViewWidget(_pupilModel),
                      if (_isLoadMoreRunning == true) _bottomLoading(),
                      if (_hasNextPage == false)
                        Container(
                          padding: const EdgeInsets.only(top: 30, bottom: 40),
                          color: Colors.amber,
                          child: Center(
                            child: Text(MyWords.exist_last_list.tr()),
                          ),
                        ),
                    ],
                  ),
                ));
  }

  SizedBox _bottomLoading() {
    return const SizedBox(
      height: 50,
      width: double.infinity,
      child: Center(
        child: CircularProgressIndicator(color: MyColors.baseWhiteColor),
      ),
    );
  }

  Container _centerLoading() {
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: const Center(
          child: CircularProgressIndicator(color: MyColors.baseWhiteColor),
        ));
  }

  Widget _centerFilterLoading() {
    return Expanded(
      child: Container(
          child: const Center(
        child: CircularProgressIndicator(color: MyColors.baseWhiteColor),
      )),
    );
  }

  Expanded _listViewWidget(AllPupilModel pupilModel) {
    return pupilModel.results.length != 0
        ? Expanded(
            child: RefreshIndicator(
              onRefresh: _filterLoad,
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: _controller,
                  itemCount: pupilModel.results.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 8),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        _slidable(pupilModel.results[index]),
                        SizedBox(height: 16),
                        Divider(color: MyColors.baseLightColor, thickness: 2)
                      ],
                    );
                  }),
            ),
          )
        : Expanded(
            child: Container(
            child: Center(
                child: Text(
              MyWords.no_info.tr(),
              style: MyStyles.White18,
            )),
          ));
  }

  Widget _slidable(Result result) {
    return Slidable(

      child: _listItemWidget(result),
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.
         //   dismissible: DismissiblePane(onDismissed: () {}),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (BuildContext context){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChildMainInfo.screen(result.id)));
                },
                backgroundColor: MyColors.baseSecondaryColor,
                foregroundColor: MyColors.baseOrangeColor,
                icon: Icons.info,
                label: MyWords.info.tr(),
              ),
            ]),
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          //   dismissible: DismissiblePane(onDismissed: () {}),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (BuildContext context){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChildUpdateScreen.screen(result.id))).then((value){
                  setState(() {
                  });
                });
              },
              backgroundColor: MyColors.baseSecondaryColor,
              foregroundColor: MyColors.baseOrangeColor,
              icon: Icons.edit,
              label: MyWords.edit.tr(),
            ),
          ]),
    );
  }

  Row _filterWidget(ChildClassModel classModel, ChildGroupModel groupModel) {
    return Row(
      children: [
        DropdownButton<String>(
          focusColor: Colors.white,
          value: _chosenValue,
          icon: const Icon(
            // Add this
            Icons.arrow_drop_down, // Add this
            color: MyColors.baseWhiteColor, // Add this
          ),
          style: TextStyle(color: MyColors.baseWhiteColor),
          iconEnabledColor: MyColors.baseWhiteColor,
          selectedItemBuilder: (BuildContext ctxt) {
            return classModel.results.map<Widget>((item) {
              return DropdownMenuItem(
                  child: Text("${item.title}",
                      style: TextStyle(color: MyColors.baseWhiteColor)),
                  value: item.title);
            }).toList();
          },
          items: classModel.results.map((item) {
            return DropdownMenuItem<String>(
              value: item.title,
              child: Text(
                item.title,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: const Text(
            "status",
            style: TextStyle(
              color: MyColors.baseWhiteColor,
              fontSize: 14,
            ),
          ),
          onChanged: (String? value) {
            _chosenValue = value!;
            for (int i = 0; i < classModel.results.length; i++) {
              if (classModel.results[i].title == _chosenValue) {
                _chosenClass = classModel.results[i].id;
                break;
              }
            }

            _getGroup(_chosenClass);
            _groupClass = groupModel.list[0].id;
            _groupValue = _groupModel.list[0].title;
            // classs
            _filterLoad();
          },
        ),
        Spacer(),
        DropdownButton<String>(
          focusColor: Colors.white,
          value: _groupValue,
          icon: const Icon(
            // Add this
            Icons.arrow_drop_down, // Add this
            color: MyColors.baseWhiteColor, // Add this
          ),
          style: TextStyle(color: MyColors.baseWhiteColor),
          iconEnabledColor: MyColors.baseWhiteColor,
          selectedItemBuilder: (BuildContext ctxt) {
            return groupModel.list.map<Widget>((item) {
              return DropdownMenuItem(
                  child: Text("${item.title}",
                      style: TextStyle(color: MyColors.baseWhiteColor)),
                  value: item.title);
            }).toList();
          },
          items: groupModel.list.map((item) {
            return DropdownMenuItem<String>(
              value: item.title,
              child: Text(
                item.title,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: const Text(
            "status",
            style: TextStyle(
              color: MyColors.baseWhiteColor,
              fontSize: 14,
            ),
          ),
          onChanged: (String? value) {
            _groupValue = value!;
            for (int i = 0; i < groupModel.list.length; i++) {
              if (groupModel.list[i].title == _groupValue) {
                _groupClass = groupModel.list[i].id;
                break;
              }
            }
            _filterLoad();
          },
        ),
      ],
    );
  }

  Widget _listItemWidget(Result result) {
    return Column(
      children: [
        Row(
          children: [
            result.photo == ""
                ? SizedBox(
                    width: 76,
                    height: 98,
                    child: Image.asset('assets/image/no_image.png'))
                : SizedBox(
                    width: 76,
                    height: 98,
                    child: CachedNetworkImage(
                      imageUrl: result.photo,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 76,
                        height: 98,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 4, color: MyColors.baseWhiteColor),
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
                          (context, url, downloadProgress) => Center(
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
                      result.firstName.toUpperCase() +
                          " " +
                          result.lastName.toUpperCase() +
                          " " +
                          result.middleName.toUpperCase(),
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: 18, color: MyColors.baseWhiteColor)),
                ),
                SizedBox(height: 8),
              ],
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraScreen.screen(
                            widget.cameraDescription, result.id)),
                  ).then((value) {
                    initState();
                  });
                },
                icon: Icon(Icons.camera, color: MyColors.baseWhiteColor))
          ],
        ),
      ],
    );
  }

  Future _getGroup(int id) async {
    GroupModel model = GroupModel(
        id: 0, title: MyWords.all_group.tr(), className: ClassName.empty());
    _groupModel = await _service.getChildGroup(_token, id);
    _groupModel.list.insert(0, model);
    for (int i = 0; i < _groupModel.list.length; i++) {
      print(_groupModel.list[i].title);
    }
    setState(() {});
  }

  Future _getClass() async {
    ResultClass firstClass = ResultClass(
        id: 0,
        createdDate: DateTime(0),
        modifiedDate: DateTime(0),
        title: MyWords.all_class.tr());
    _classModel = await _service.getChildClass(_token);
    _classModel.results.insert(0, firstClass);
  }

  Future<void> _registerBus() async {
    RxBus.register<UserLoggedInModel>(tag: "EVENT_LIST").listen(
      (event) {
        _classModel.results[0].title = event.valueClass;
        _groupModel.list[0].title = event.valueGroup;
        _groupValue = event.valueGroup;
        _chosenValue = event.valueClass;
        setState(() {});
      },
    );
  }
}
