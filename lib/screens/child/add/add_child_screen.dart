
import 'dart:io';
import 'dart:io';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unikids_uz/model/local_child_add_,model.dart';
import 'package:unikids_uz/model/rxbus_list_model.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/child/add/bloc/child_add_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/widgets/drop_down/awesome_drop_down.dart';
import 'package:unikids_uz/widgets/mytext_field.dart';
import 'dart:io' as Io;


class ChildAddScreen extends StatefulWidget {

  static Widget screen() => BlocProvider(
    create: (context) => ChildAddBloc(context: context),
    child: ChildAddScreen(),
  );

  @override
  _ChildAddScreenState createState() => _ChildAddScreenState();
}

class _ChildAddScreenState extends State<ChildAddScreen> {
  late ChildAddBloc bloc;

  String radioItem = 'male';
  final picker = ImagePicker();
  late Future<PickedFile?> pickedFile = Future.value(null);
  int childGroupId = 0;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerMiddleName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  TextEditingController _contorollerAdress = TextEditingController();
  TextEditingController _contorollerBirthDay = TextEditingController();
  late PickedFile selectedFile;

  late String _selectedItem;
  bool isDropDownSelect = false;
  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;
  bool _value = false;

  late String _selectedItem2;
  bool isDropDownSelect2= false;
  bool _isBackPressedOrTouchedOutSide2 = false,
      _isDropDownOpened2 = false,
      _isPanDown2 = false;
  bool _value2 = false;
  late int _selectID = 0;
  String filePath = '';
  String fileName = '';
  bool validate = false;


  @override
  void initState() {
    bloc = BlocProvider.of<ChildAddBloc>(context);
    _selectedItem = MyWords.selec_class.tr();
    _selectedItem2 = MyWords.selec_group.tr();
   // bloc.add(Load());
    _registerBus();
    // bloc.add(LoadClass());
    // bloc.add(LoadGroup(id: 0));
    super.initState();
  }

  Future<void> _registerBus() async {
    RxBus.register<String>(tag: "Class").listen(
          (event) {
        if (event == "Ok") {
           bloc.add(LoadClass());
        }
        else{
          print(")))))))))))))))))");
          bloc.add(LoadGroup(id: _selectID));
        }
      },
    );
  }

  _getImage() async {
    pickedFile = picker
        .getImage(
      source: ImageSource.gallery,
    )
        .whenComplete(() => {setState(() {})});
    selectedFile = (await pickedFile)!;
    File file = File(selectedFile.path);
    filePath = file.path;
    fileName = file.path.split('/').last;
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
            child: Center(
                child:
                CircularProgressIndicator(color: Colors.white)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
       leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
         Navigator.pop(context);
       }, color: Colors.white),
       backgroundColor: MyColors.baseOrangeColor,
        title: Text(MyWords.child_add.tr(), style: TextStyle(color: Colors.white),),
      ),
      body: BlocConsumer<ChildAddBloc, ChildAddState>(
  listener: (context, state) {
   if(state is DoneLoading){
     _onLoading();
   }
   else if(state is Done){
     showToast(MyWords.add_list.tr(), Colors.green);
     Navigator.pop(context);
     Navigator.pop(context);
   }
   else if(state is Error){
     showToast(state.error, Colors.red);
   }
  },
  builder: (context, state) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Row(
                  children: [
                    FutureBuilder<PickedFile?>(
                      future: pickedFile,
                      builder: (context, snap) {
                        if(snap.connectionState == ConnectionState.waiting){
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      8),
                                  border: Border.all(
                                      color: MyColors.baseOrangeColor,
                                      width: 2)
                              ),
                              child: Center(
                                  child:
                                  CircularProgressIndicator(color: MyColors.baseOrangeColor)), //  color: Colors.white,
                            ),
                          );
                        }
                        if (snap.error != null) {
                          return Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      8),
                                  border: Border.all(
                                      color: MyColors.baseOrangeColor,
                                      width: 2)
                              ),
                              child: Center(
                                  child: Text(MyWords.error_occured.tr())), //  color: Colors.white,
                            ),
                          );
                        }
                        if (snap.hasData) {
                          return Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: (){
                                _getImage();
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      8),
                                  border: Border.all(
                                      color: MyColors.baseOrangeColor,
                                      width: 2)
                                ),
                                child: Image.file(
                                  File(snap.data!.path),
                                  fit: BoxFit.cover,
                                ),
                              //  color: Colors.white,
                              ),
                            ),
                          );
                        }
                        return Expanded(flex: 1,child: GestureDetector(
                            onTap: () async {
                               _getImage();
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: MyColors.baseOrangeColor, width: 2)
                              ),
                              child: Center(
                                child: Icon(Icons.camera_alt, color: Colors.grey),
                              ),
                            )
                            //Image.asset("assets/image/no_image.png")
                        ));
                      },
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 27),
                              child: Text(MyWords.gender.tr(), style: TextStyle(color: Colors.grey, fontSize: 18),)),
                          SizedBox(
                            height: 30,
                            child: RadioListTile(
                              groupValue: radioItem,
                              activeColor: MyColors.baseOrangeColor,
                              title: Text(MyWords.child_female.tr(), style: TextStyle(color: Colors.grey)),
                              value: 'female',
                              onChanged: (val) {
                                setState(() {
                                  radioItem = val as String;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: RadioListTile(
                              activeColor: MyColors.baseOrangeColor,
                              groupValue: radioItem,
                              title: Text(MyWords.child_male.tr(), style: TextStyle(color: Colors.grey),),
                              value: 'male',
                              onChanged: (val) {
                                setState(() {
                                  radioItem = val as String;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(controller: _controllerLastName, txt:  MyWords.last_name.tr(), validate: validate,),
                    MyTextField(controller: _controllerName, txt: MyWords.first_name.tr(), validate: validate),
                    MyTextField(controller: _controllerMiddleName, txt:  MyWords.middle_name.tr(), validate: validate),
                  ],
                ),
              ),
              BlocConsumer<ChildAddBloc, ChildAddState>(
                listener: (context, state) {
                  if(state is ChildAddLoaded) {
                    // RxBusListModel model = RxBusListModel(list: state.list);
                    // RxBus.post(
                    //   model,
                    //   tag: "Loaded",
                    // );
                    // setState(() {
                    // });
                  }
                },
                builder: (context, state) {
                  if(state is ChildAddLoading)
                    return _awesomeDropDownWidgetClass([MyWords.loading.tr()], [0]);
                  if(state is ChildAddLoaded)
                    return _awesomeDropDownWidgetClass(state.list, state.id);
                  if(state is ChildAddError)
                    return _awesomeDropDownWidgetClass([state.error], [0]);
                  return _awesomeDropDownWidgetClass([MyWords.loading.tr()], [0]);
                },
              ),
              (validate && _selectedItem == MyWords.selec_class.tr()) ?  _dropDownNotFill() : SizedBox(),
              SizedBox(height: 16),
              BlocConsumer<ChildAddBloc, ChildAddState>(
                listener: (context, state) {
                  if(state is ChildAddLoading)
                    print("loading");
                  if(state is ChildAddGroupLoaded) {

                  }
                },
                builder: (context, state) {
                  if(state is ChildAddGroupLoaded)
                    return _awesomeDropDownWidgetGroup(state.list, state.id);
                  if(state is ChildAddError)
                    return _awesomeDropDownWidgetGroup([state.error], [0]);
                  return _awesomeDropDownWidgetGroup([MyWords.loading.tr()], [0]);
                },
              ),
              (validate && _selectedItem2 == MyWords.selec_group.tr()) ?
              _dropDownNotFill() : SizedBox(),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(controller: _contorollerAdress, txt:  MyWords.adress.tr(), validate: validate),
                    MyTextField(controller: _contorollerBirthDay, txt:  MyWords.birth_day.tr(), icon: true, validate: validate),
                    Row(
                      children: [
                        Switch(
                          activeColor: MyColors.baseOrangeColor,
                          value: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          },
                        ),
                        Text( MyWords.status.tr(), style: TextStyle(color: Colors.grey),)
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50, right: 50),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          validate = true;
                          _postAddChild();
                          setState(() {
                          });
                        },
                        child: Text(MyWords.save.tr()),
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.baseOrangeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  },
),
    );
  }

  Widget _dropDownNotFill() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        SizedBox(width: 16),
        Text(MyWords.value_not_empty.tr(), style: TextStyle(
                        color: Colors.red, fontSize: 11, fontWeight: FontWeight.normal),),
      ],
    );
  }



  AwesomeDropDown _awesomeDropDownWidgetClass(List<String> list, List<int> listId) {
    return AwesomeDropDown(
      type: true,
      padding: 0,
      isPanDown: _isPanDown,
      isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide,
      dropDownBGColor: Colors.white,
      dropDownOverlayBGColor: Colors.transparent,
      dropDownTopBorderRadius: 8,
      dropDownBottomBorderRadius: 8,
      dropDownIconBGColor: Colors.transparent,
      dropDownList: list,
      selectedItem: isDropDownSelect ? _selectedItem : MyWords.selec_class.tr(),
      numOfListItemToShow: 4,
      selectedItemTextStyle:  TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
      dropDownListTextStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
          backgroundColor: Colors.transparent),
      onDropDownItemClick: (selectedItem) {
        RxBus.post(
          "color",
          tag: "ItemClick",
        );
        _selectedItem = selectedItem;
         int index =  _filter(list, _selectedItem);
         _selectID = listId[index];
        print("SELECT " + _selectedItem);
        isDropDownSelect = true;
        _selectedItem2 =  MyWords.selec_group.tr();
        setState(() {
        });
      },
      dropStateChanged: (isOpened) {
        _isDropDownOpened = isOpened;
        if (!isOpened) {
          _isBackPressedOrTouchedOutSide = false;
        }
      },
    );
  }

  AwesomeDropDown _awesomeDropDownWidgetGroup(List<String> list, List<int> listId) {
    return AwesomeDropDown(
      type: false,
      padding: 0,
      isPanDown: _isPanDown2,
      isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide2,
      dropDownBGColor: Colors.white,
      dropDownOverlayBGColor: Colors.transparent,
      dropDownTopBorderRadius: 8,
      dropDownBottomBorderRadius: 8,
      dropDownIconBGColor: Colors.transparent,
      dropDownList: list,
      selectedItem: isDropDownSelect2 ? _selectedItem2 : MyWords.selec_group.tr(),
      numOfListItemToShow: 4,
      selectedItemTextStyle: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
      dropDownListTextStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
          backgroundColor: Colors.transparent),
      onDropDownItemClick: (selectedItem) {
        RxBus.post(
          "color",
          tag: "ItemClick",
        );
        _selectedItem2 = selectedItem;
        for(int  i = 0; i < list.length; i++){
          if(_selectedItem2 == list[i]){
            childGroupId = listId[i];
            break;
          }
        }
        isDropDownSelect2 = true;
      },
      dropStateChanged: (isOpened) {
        _isDropDownOpened2 = isOpened;
        if (!isOpened) {
          _isBackPressedOrTouchedOutSide2 = false;
        }
      },
    );
  }
  
  int _filter(List<String> list,  String selectTitle){
    int index = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == selectTitle) {
        index = i;
        break;
      }
    }
    return index;
  }

  void  _postAddChild(){
    if(_controllerName.text != "" && _controllerLastName.text != "" && _controllerMiddleName.text != "" && _contorollerBirthDay.text != "" && _contorollerAdress.text != ""
     && _selectedItem != MyWords.selec_class.tr() && _selectedItem2 != MyWords.selec_group.tr() && _contorollerBirthDay.text.length == 10){
      if(filePath == "" || fileName == ""){
        showToast(MyWords.select_not_picture.tr(), Colors.red);
      }
      else {
        String birth = _contorollerBirthDay.text.substring(6, 10);
        birth += "-" + _contorollerBirthDay.text.substring(3, 5);
        birth += "-" + _contorollerBirthDay.text.substring(0, 2);
        print(birth);
      LocalChildAddModel model = LocalChildAddModel(
            first_name: _controllerName.text,
            last_name: _controllerLastName.text,
            middle_name: _controllerMiddleName.text,
            child_group: childGroupId,
            address: _contorollerAdress.text,
            birth_date: birth,
            joined_date: kToday.toString().substring(0, 10),
            gender_type: radioItem,
            is_active: _value);
        bloc.add(Add(model: model, filePath: filePath, fileName: fileName));
      }
    }
    else{
      print("Empty");
    }
  }


}
