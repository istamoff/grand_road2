
import 'dart:io';
import 'dart:io';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unikids_uz/model/local_child_add_,model.dart';
import 'package:unikids_uz/model/parents/human_model.dart';
import 'package:unikids_uz/model/parents/local_parent_add_model.dart';
import 'package:unikids_uz/model/parents/relative_type_model.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab2/add/bloc/parents_add_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/widgets/drop_down/awesome_drop_down.dart';
import 'package:unikids_uz/widgets/mynumber_textfield.dart';
import 'package:unikids_uz/widgets/mytext_field.dart';
import 'dart:io' as Io;


class ParentsUpdateScreen extends StatefulWidget {
  final int id;

  static Widget screen(id) => BlocProvider(
    create: (context) => ParentsAddBloc(),
    child: ParentsUpdateScreen(id: id),
  );

  ParentsUpdateScreen({required this.id});

  @override
  _ParentsUpdateScreenState createState() => _ParentsUpdateScreenState();
}

class _ParentsUpdateScreenState extends State<ParentsUpdateScreen> {
  late ParentsAddBloc bloc;
  List<TextEditingController> _controllers = [];

  var maskFormatter = MaskTextInputFormatter(
      mask: '+### (##) ###-##-##', filter: {"#": RegExp(r'[0-9]')});


  final picker = ImagePicker();
  late Future<PickedFile?> pickedFile = Future.value(null);

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerMiddleName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  late PickedFile selectedFile;

  late String _selectedItem;
  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;

  bool isDropDownSelect2= false;
  bool _isBackPressedOrTouchedOutSide2 = false,
      _isDropDownOpened2 = false,
      _isPanDown2 = false;
  bool _value2 = false;
  late int _selectID = 0;
  String filePath = '';
  String fileName = '';
  bool validate = false;
  bool firstTime = true;


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
  void initState() {
    bloc = BlocProvider.of<ParentsAddBloc>(context);
    bloc.add(Update(id: widget.id));
    super.initState();
  }


  _loadInfo(HumansModel model){
    if(firstTime) {
      _selectID = model.relativityId;
      _selectedItem = model.genderType;
      _controllerName.text = model.firstName;
      _controllerMiddleName.text = model.middleName;
      _controllerLastName.text = model.lastName;
      for (int i = 0; i < model.contacts.length; i++) {
        _controllers.add(TextEditingController(text: model.contacts[i]));
      }
      firstTime = false;
    }
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerMiddleName.dispose();
    _controllerLastName.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.initState();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
        }, color: Colors.white),
        backgroundColor: MyColors.baseOrangeColor,
        title: Text(MyWords.parents_update.tr(), style: TextStyle(color: Colors.white),),
      ),
      body: BlocConsumer<ParentsAddBloc, ParentsAddState>(
        listener: (context, state) {
          if(state is Done){
            _showToast(Colors.green, MyWords.success_update.tr());
           Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if(state is UpdateLoaded) {
            _loadInfo(state.model);
             return Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Row(
                        children: [
                          FutureBuilder<PickedFile?>(
                            future: pickedFile,
                            builder: (context, snap) {
                              if(snap.connectionState == ConnectionState.waiting){
                                Expanded(
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
                                        fit: BoxFit.fitWidth,
                                      ),
                                      //  color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                              return Expanded( child: GestureDetector(
                                  onTap: () async {
                                    _getImage();
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: state.model.photo,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                8),
                                            border: Border.all(
                                                color: MyColors.baseOrangeColor,
                                                width: 2),
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
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                              )
                              );
                            },
                          ),
                          // Expanded(
                          //   flex: 2,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: <Widget>[
                          //       Container(
                          //           margin: EdgeInsets.only(left: 27),
                          //           child: Text(MyWords.new_parent_list.tr(), style: TextStyle(color: Colors.grey, fontSize: 18),)),
                          //       SizedBox(
                          //         height: 30,
                          //         child: RadioListTile(
                          //           groupValue: radioItem,
                          //           activeColor: MyColors.baseOrangeColor,
                          //           title: Text(MyWords.parent_new_radio.tr(), style: TextStyle(color: Colors.grey)),
                          //           value: 'new',
                          //           onChanged: (val) {
                          //             setState(() {
                          //               radioItem = val as String;
                          //             });
                          //           },
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 30,
                          //         child: RadioListTile(
                          //           activeColor: MyColors.baseOrangeColor,
                          //           groupValue: radioItem,
                          //           title: Text(MyWords.parent_select_radio.tr(), style: TextStyle(color: Colors.grey),),
                          //           value: 'exist',
                          //           onChanged: (val) {
                          //             setState(() {
                          //               radioItem = val as String;
                          //             });
                          //           },
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          //
                          // )
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
                   _awesomeDropDown(state.listDrop, state.listId),
                    (validate && _selectedItem == MyWords.selec_class.tr()) ?  _dropDownNotFill() : SizedBox(),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._controllers.map((personController) => _buildCard(personController)),
                          Container(
                            margin: EdgeInsets.only(left: 50, right: 50),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                validate = true;
                                setState(() {
                                });
                                _updateBtn();
                              },
                              child: Text(MyWords.update_btn.tr()),
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
          }
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                  child:
                  CircularProgressIndicator(color: MyColors.baseOrangeColor)),
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


  AwesomeDropDown _awesomeDropDown(List<String> list, List<int> listId) {
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
      selectedItem: _selectedItem,
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

  Widget _buildCard(TextEditingController controller){
    return  Row(
      children: [
        Expanded(child: MyNumberTextField(controller: controller, txt: MyWords.number.tr(), validate: validate, formatter: [maskFormatter])),
        GestureDetector(
          onTap: (){
            _controllers.add(TextEditingController());
          //  deleteBtn = true;
            setState(() {
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 10, bottom: 16),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MyColors.baseBlueColor,
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
        // GestureDetector(
        //   onTap: (){
        //
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(left: 10, bottom: 16),
        //     height: 50,
        //     width: 50,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8),
        //       color: MyColors.baseRedColor,
        //     ),
        //     child: Icon(Icons.delete, color: Colors.white),
        //   ),
        // )
      ],
    );
  }

  void  _updateBtn(){
    bool isFillController = true;
    if(_controllerName.text != "" && _controllerLastName.text != "" && _controllerMiddleName.text != ""
        && _selectedItem != MyWords.selec_class.tr()){
      if(_controllers.length > 0)
      {
        for(int i = 0; i < _controllers.length; i++){
          if(_controllers[i].text == ""){
            isFillController  = false;
            break;
          }
        }
      }
      if(isFillController){
          LocalParentAddModel model = LocalParentAddModel(
              first_name: _controllerName.text,
              last_name: _controllerLastName.text,
              middle_name: _controllerMiddleName.text,
              child: widget.id,
              contacts: _controllers,
              relativity_type: _selectID,
              number: TextEditingController());
          bloc.add(UpdateBtn(id: widget.id, model: model, filePath: filePath, fileName: fileName));
        }

    }
    else{
      print("Empty");
    }
  }



}
