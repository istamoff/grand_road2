import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab2/add/bloc/parents_add_bloc.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab3/bloc/child_document_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/widgets/drop_down/awesome_drop_down.dart';

class ChildDocumentScreen extends StatefulWidget {
  final int id;

  static Widget screen(id) =>
      BlocProvider(
        create: (context) => ChildDocumentBloc(),
        child: ChildDocumentScreen(id: id),
      );

  ChildDocumentScreen({required this.id});

  @override
  _ChildDocumentScreenState createState() => _ChildDocumentScreenState();
}

class _ChildDocumentScreenState extends State<ChildDocumentScreen> {
  String _selectedItem = "";
  late ChildDocumentBloc bloc;
  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;
  late int _selectID = 0;
  String _selecTxt = "";
  late  PlatformFile file;
  bool validate = false;


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
  void initState() {
    bloc = BlocProvider.of<ChildDocumentBloc>(context);
    bloc.add(DocumentType());
    _selecTxt = MyWords.select_file.tr();
    super.initState();
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
    print("IDS " + widget.id.toString());
    return BlocConsumer<ChildDocumentBloc, ChildDocumentState>(
      listener: (context, state) {
        if(state is ChildDocumentLoading)
          _onLoading();
        if(state is ChildDocumentLoaded){
          Navigator.pop(context);
        }
        if(state is SaveLoaded) {
          Navigator.pop(context);
          _showToast(Colors.green, MyWords.success_save.tr());
        }
        if(state is ChildDocumentError){
          Navigator.pop(context);
          _showToast(Colors.red, state.error);
        }
        if(state is ChildDocumentSaveLoading)
          _onLoading();
      },
      builder: (context, state) {
        if(state is ChildDocumentLoaded) {
          return Column(
          children: [
            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'pdf', 'doc'],
                );
                if (result != null) {
                  file = result.files.first;
                  _selecTxt = file.name;

                  setState(() {
                  });
                } else {
                  // User canceled the picker
                }

              },
              child: Container(
                margin: EdgeInsets.only(top: 16,  left: 4, right: 4),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(_selecTxt != "" ? (_selecTxt.length >= 25 ? _selecTxt.substring(0, 25) + "..." : _selecTxt) : _selecTxt, style: TextStyle(color: Colors.grey),   maxLines: 1,
                          softWrap: false,)),
                    Spacer(),
                    Container(height: 50, width: 1, color: Colors.grey),
                    Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text(MyWords.download.tr(), style: TextStyle(color: Colors.grey),))
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            (validate && _selecTxt == MyWords.select_file.tr()) ?  _dropDownNotFill(MyWords.empty_documenty.tr()) : SizedBox(),
            SizedBox(height: 16),
            _awesomeDropDown(state.listDrop, state.listId),
            SizedBox(height: 4),
        (validate  && _selectedItem == "") ?  _dropDownNotFill(MyWords.empty_documenty_type.tr()) : SizedBox(),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveFunc();
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
        );
        }
        if(state is SaveLoaded) {
          return Column(
          children: [
            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'pdf', 'doc'],
                );
                if (result != null) {
                  file = result.files.first;
                  _selecTxt = file.name;

                  setState(() {
                  });
                } else {
                  // User canceled the picker
                }

              },
              child: Container(
                margin: EdgeInsets.only(top: 16,  left: 4, right: 4),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(_selecTxt, style: TextStyle(color: Colors.grey),)),
                    Spacer(),
                    Container(height: 50, width: 1, color: Colors.grey),
                    Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text(MyWords.download.tr(), style: TextStyle(color: Colors.grey),))
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            (validate && _selecTxt == MyWords.select_file.tr()) ?  _dropDownNotFill(MyWords.empty_documenty.tr()) : SizedBox(),
            SizedBox(height: 16),
            _awesomeDropDown(state.listDrop, state.listId),
            SizedBox(height: 4),
            (validate  && _selectedItem == "") ?  _dropDownNotFill(MyWords.empty_documenty_type.tr()) : SizedBox(),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveFunc();
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
        );
        }
        if(state is ChildDocumentSaveLoading){
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'pdf', 'doc'],
                  );
                  if (result != null) {
                    file = result.files.first;
                    _selecTxt = file.name;

                    setState(() {
                    });
                  } else {
                    // User canceled the picker
                  }

                },
                child: Container(
                  margin: EdgeInsets.only(top: 16,  left: 4, right: 4),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(_selecTxt, style: TextStyle(color: Colors.grey),)),
                      Spacer(),
                      Container(height: 50, width: 1, color: Colors.grey),
                      Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Text(MyWords.download.tr(), style: TextStyle(color: Colors.grey),))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4),
              (validate && _selecTxt == MyWords.select_file.tr()) ?  _dropDownNotFill(MyWords.empty_documenty.tr()) : SizedBox(),
              SizedBox(height: 16),
              _awesomeDropDown(state.listDrop, state.listId),
              SizedBox(height: 4),
              (validate  && _selectedItem == "") ?  _dropDownNotFill(MyWords.empty_documenty_type.tr()) : SizedBox(),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveFunc();
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
          );
        }
        if(state is ChildDocumentError) {
          return Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: Text(state.error),
          );
        }
        return Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
        );
      },
    );
  }

  void _saveFunc(){
    try {
      if (_selectedItem != MyWords.select_file.tr() && _selecTxt != "") {
        bloc.add(Save(fileName: file.name,
            filePath: file.path!,
            fileType: _selectID,
            objectId: widget.id));
      }
      else {
        validate = true;
      }
    }catch(e){
      validate = true;
    }
    setState(() {});
  }

  Widget _dropDownNotFill(String txt) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        SizedBox(width: 16),
        Text(txt, style: TextStyle(
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


}
