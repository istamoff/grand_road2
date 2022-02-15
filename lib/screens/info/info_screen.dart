import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:unikids_uz/model/response_model.dart';
import 'package:unikids_uz/model/status_model.dart';
import 'package:unikids_uz/screens/info/bloc/info_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/widgets/item_widget.dart';
import 'package:unikids_uz/widgets/login_button.dart';

class InfoScreen extends StatefulWidget {
  final InfoModel model;
  final List<StatusModel> list;

  static Widget screen(model, list) => BlocProvider(
        create: (context) => InfoBloc(context: context),
        child: InfoScreen(model: model, list: list),
      );

  InfoScreen({required this.model, required this.list});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late String formattedDate;
  TextEditingController _controller = TextEditingController();
  double temperature = 36.6;
  late String _chosenValue;
  late InfoBloc bloc;
  late int statusId;
  bool isSelectChild = false;
  int isSelectChildIndex = 0;

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

  @override
  void initState() {
    _controller.text = temperature.toString();
    formattedDate = DateFormat('kk:mm:ss \n EEE d MMM')
        .format(DateTime.now())
        .substring(0, 5);
    _chosenValue = widget.list[0].title;
    bloc = BlocProvider.of<InfoBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: MyColors.baseSecondaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(left: 24, right: 24, top: 24),
      child:

      (!isSelectChild && widget.model.result.length != 1)  ? ListView.separated(
        // reverse: true,
         itemCount: widget.model.result.length,
         separatorBuilder: (BuildContext context, int index) =>
             SizedBox(height: 8),
         itemBuilder: (BuildContext context, int index) {
           return _itemResponseWidget(widget.model.result[index], index);
         }) : Column(
        children: [
          _responseWidget(),
          Row(
            children: [
              _tempWidget(),
              Expanded(child: SizedBox()),
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
                  return widget.list.map<Widget>((item) {
                    return DropdownMenuItem(
                        child: Text("${item.title}",
                            style: TextStyle(color: MyColors.baseWhiteColor)),
                        value: item.title);
                  }).toList();
                },
                items: widget.list.map((item) {
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
                  setState(() {
                    _chosenValue = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 25),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              child: ListView.separated(
                  itemCount: widget.model.result[isSelectChildIndex].humans.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 16),
                  itemBuilder: (BuildContext context, int index) {
                    return ListItemWidget(
                      human: widget.model.result[isSelectChildIndex].humans[index],
                      index: index,
                      checked: MyContants.INDEX == index ? true : false,
                      onTapItem: () {
                        MyContants.INDEX = index;
                        setState(() {
                        });
                      },
                    );
                  }),
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              if(double.parse(_controller.text.toString()) < 33 || double.parse(_controller.text.toString()) > 45){

              }
              else {
                bool isConnect = await checkInternetConnection();
                for (int i = 0; i < widget.list.length; i++) {
                  if (_chosenValue == widget.list[i].title)
                    statusId = widget.list[i].id;
                }
                print("STATUS ID");
                if (isConnect) {
                  bloc.add(InfoLoadEvent(
                      child: widget.model.result[isSelectChildIndex].id,
                      status: statusId,
                      come_in_person: widget.model.result[isSelectChildIndex]
                          .humans[MyContants.INDEX].id,
                      temperature: double.parse(_controller.text)));
                } else
                  MyContants.showToast(MyWords.no_internet_connection.tr(),
                      MyColors.baseSecondaryColor);
              }
            },
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: MyColors.baseSecondaryColor,
                border: Border.all(color: MyColors.baseLightColor, width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              child: Center(
                  child: Text(MyWords.submit.tr(),
                      style: TextStyle(color: MyColors.baseWhiteColor))),
            ),
          ),
          SizedBox(height: 8),

          //o'chirish kerak
          // ListView.builder(
          //   itemCount: 3,
          //   itemBuilder: (context, i) {
          //     int index = -1;
          //     return GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           index = i;
          //         });
          //       },
          //       behavior: HitTestBehavior.opaque,
          //       child: index == i ? Text('1') : Text('2'),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _tempWidget() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (temperature > MyContants.MINGRADUS) {
                      temperature -= 0.1;
                      _controller.text = temperature.toString().substring(0, 4);
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.remove),
                  color: MyColors.baseWhiteColor),
              SizedBox(width: 4),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyColors.baseWhiteColor),
                  onChanged: (text){

                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors.baseLightColor, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: MyColors.baseLightColor, width: 0.0),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4),
              IconButton(
                  onPressed: () {
                    if(temperature < MyContants.MAXGRADUS) {
                      temperature += 0.1;
                      _controller.text = temperature.toString().substring(0, 4);
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.add),
                  color: MyColors.baseWhiteColor),
            ],
          ),
          SizedBox(height: 4),
          (double.parse(_controller.text.toString() == "" ? "0" : _controller.text.toString()) < MyContants.MINGRADUS || double.parse(_controller.text.toString() == "" ? "0" : _controller.text.toString()) > MyContants.MAXGRADUS) ? Text(MyWords.invalid_value.tr(), style: TextStyle(color: MyColors.baseOrangeColor, fontSize: 11)) : SizedBox(),
        ],
      ),
    );
  }


  Widget _itemResponseWidget(Result result, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        isSelectChildIndex = index;
        isSelectChild = true;
        setState(() {
        });
      },
      child: Container(
        color: MyColors.baseSecondaryColor,
        margin: EdgeInsets.only(bottom: 8),
        child: Container(
          height: 142,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MyColors.baseLightBgColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Container(
                width: 82,
                height: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: result.photo != ""
                        ? NetworkImage(result
                        .photo) //     NetworkImage(_baseUrl + widget.model.result.photo)
                        : AssetImage('assets/image/no_image.png')
                    as ImageProvider,
                    fit: BoxFit.fill,
                  ), // _baseUrl + widget.model.result.photo
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 4, color: MyColors.baseWhiteColor),
                  boxShadow: const [
                    BoxShadow(
                        color: MyColors.baseWeightShadowColor,
                        blurRadius: 4,
                        spreadRadius: 0.25),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text(widget.model.result.firstName.toUpperCase() + " " + widget.model.result.lastName,
                  //     style: TextStyle(fontSize: 14, color: Colors.white)),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: Text(
                       result.firstName.toUpperCase() +
                            " " +
                            result.lastName.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 16, color: MyColors.baseWhiteColor)),
                  ),
                  // Text(widget.model.result.middleName.toUpperCase(),
                  //     style: TextStyle(fontSize: 14, color: Colors.white)),
                  SizedBox(
                    height: 24,
                    width: 150,
                    child: Text(
                       result.childGroup.className
                            .toUpperCase() +
                            " " +
                           result.childGroup.title.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 16,
                            color: MyColors.baseLightColor,
                            fontWeight: FontWeight.bold)),
                  ),
                  //   Text(widget.model.result.childGroup.childGroupClass.toUpperCase() + widget.model.result.childGroup.title.toUpperCase(), style: TextStyle(color: Colors.white),),
                  //   SizedBox(height: 8),
                  Text(formattedDate,
                      style: TextStyle(fontSize: 36, color: Colors.white))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _responseWidget() {
    return Container(
      color: MyColors.baseSecondaryColor,
      margin: EdgeInsets.only(bottom: 25),
      child: Container(
        height: 142,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyColors.baseLightBgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Container(
              width: 82,
              height: 110,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.model.result[isSelectChildIndex].photo != ""
                      ? NetworkImage(widget.model.result[isSelectChildIndex]
                          .photo) //     NetworkImage(_baseUrl + widget.model.result.photo)
                      : AssetImage('assets/image/no_image.png')
                          as ImageProvider,
                  fit: BoxFit.fill,
                ), // _baseUrl + widget.model.result.photo
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 4, color: MyColors.baseWhiteColor),
                boxShadow: const [
                  BoxShadow(
                      color: MyColors.baseWeightShadowColor,
                      blurRadius: 4,
                      spreadRadius: 0.25),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text(widget.model.result.firstName.toUpperCase() + " " + widget.model.result.lastName,
                //     style: TextStyle(fontSize: 14, color: Colors.white)),
                SizedBox(
                  height: 40,
                  width: 150,
                  child: Text(
                      widget.model.result[isSelectChildIndex].firstName.toUpperCase() +
                          " " +
                          widget.model.result[isSelectChildIndex].lastName.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: 16, color: MyColors.baseWhiteColor)),
                ),
                // Text(widget.model.result.middleName.toUpperCase(),
                //     style: TextStyle(fontSize: 14, color: Colors.white)),
                SizedBox(
                  height: 24,
                  width: 150,
                  child: Text(
                      widget.model.result[isSelectChildIndex].childGroup.className
                              .toUpperCase() +
                          " " +
                          widget.model.result[isSelectChildIndex].childGroup.title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: 16,
                          color: MyColors.baseLightColor,
                          fontWeight: FontWeight.bold)),
                ),
                //   Text(widget.model.result.childGroup.childGroupClass.toUpperCase() + widget.model.result.childGroup.title.toUpperCase(), style: TextStyle(color: Colors.white),),
                //   SizedBox(height: 8),
                Text(formattedDate,
                    style: TextStyle(fontSize: 36, color: Colors.white))
              ],
            )
          ],
        ),
      ),
    );
  }
}
