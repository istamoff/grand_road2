import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/child/error_image_valid_model.dart';
import 'package:unikids_uz/model/child_info_model.dart';
import 'package:unikids_uz/model/local_child_add_,model.dart';
import 'package:unikids_uz/model/update_pupil/child_class_model.dart';
import 'package:unikids_uz/model/update_pupil/child_group_short_list_model.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';
import 'dart:io' as Io;

part 'child_add_event.dart';
part 'child_add_state.dart';

class ChildAddBloc extends Bloc<ChildAddEvent, ChildAddState> {
  BuildContext context;
  final MyService _service = locator.get<MyService>();
  late ChildClassModel _classModel = ChildClassModel.empty();
  late ChildGroupModel _groupModel = ChildGroupModel.empty();
  late ChildInfoModel _childInfoModel = ChildInfoModel.empty();
  late ErrorImageValidModel _validModel = ErrorImageValidModel.empty();
  late LocalChildAddModel _model;
  late String _token = "";
  late List<String> listClass = [];
  late List<int> listClassId = [];

  ChildAddBloc({required this.context}) : super(ChildAddInitial()) {
    on<ChildAddEvent>((event, emit) async {
      if(event is LoadClass)
        await  _getClassList(event, emit);
      if(event is LoadGroup)
        await _getGroupList(event, emit);
      if(event is Add)
        await _addChild(event, emit);
      if(event is LoadInfo)
        await _getInfo(event, emit);
      if(event is UpdateGroup)
        await _getInfoUpdateGroup(event, emit);
      if(event is Update)
        await _updateChild(event, emit);
    });
  }


  Future<void> _getClassList(
      LoadClass event,
      Emitter<ChildAddState> emit,
      ) async {
    print("_GetClassLIST");
    if(listClassId.length == 0)
    emit(ChildAddLoading());
    if(_token == "")
     _token =  _getToken();
    print("TOKEN: " + _token.toString());
    try {
      if(listClassId.length == 0) {
        _classModel = await _service.getChildClass(_token);
        for (int i = 0; i < _classModel.results.length; i++) {
          listClass.add(_classModel.results[i].title);
          listClassId.add(_classModel.results[i].id);
        }
      }
        print("CHILD SIZE: " + listClass.length.toString());
      emit(ChildAddLoaded(list: listClass, id: listClassId));
    }catch(e){
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(ChildAddError(error: MyWords.server_error.tr()));
        }
        else {
          emit(ChildAddError(error: MyWords.undefiend_error.tr()));
        }
      }
    }
  }

  Future<void> _getGroupList(
      LoadGroup event,
      Emitter<ChildAddState> emit,
      ) async {
    emit(ChildAddLoading());
    print("EVNET GROUP EVENT");
    // listGroup.clear();
    // listGroupId.clear();
    if(_token == "")
      _token =  _getToken();
    late List<String> listGroup = [];
    late List<int> listGroupId = [];
    try {
        _groupModel = await _service.getChildGroup(_token, event.id);
        for (int i = 0; i < _groupModel.list.length; i++) {
          listGroup.add(_groupModel.list[i].title);
          listGroupId.add(_groupModel.list[i].id);
        }

      emit(ChildAddGroupLoaded(list: listGroup, id: listGroupId));
    }catch(e){
      print(e.toString());
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(ChildAddError(error: MyWords.server_error.tr()));
        }
        else {
          emit(ChildAddError(error: MyWords.undefiend_error.tr()));
        }
      }
    }
  }


  Future<void> _addChild(
      Add event,
      Emitter<ChildAddState> emit,
      ) async {
    emit(DoneLoading());
    print("EVNET GROUP EVENT");
    if(_token == "")
      _token =  _getToken();
    final image = decodeImage(Io.File(event.filePath).readAsBytesSync());
    final thumbnail = copyResize(image!, width: 354, height: 472);
    Directory directory = await getApplicationDocumentsDirectory();
    String myPath = directory.path;
    File file = Io.File('$myPath/test.jpg')
      ..writeAsBytesSync(encodePng(thumbnail));
    print("path: " + file.path);
    print(file.lengthSync());
    String fileName = file.path.split('/').last;
    try {
      _validModel = await _service.postAddChild(event.model, _token, file.path, fileName);
     if(_validModel.message.uz == ""){
        emit(Done());
     }
     else{
       Navigator.pop(context);
       showToast(context.locale == const Locale('ru', 'RU') ? _validModel.message.ru : _validModel.message.uz, Colors.red);
     }
    }catch(e){
      Navigator.pop(context);
      print(e.toString());
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          Navigator.pop(context);
          emit(Error(error: MyWords.server_error.tr()));
        }
        else {
          Navigator.pop(context);
          emit(Error(error: MyWords.undefiend_error.tr()));
        }
      }
      else
        emit(Error(error: MyWords.undefiend_error.tr()));
    }
  }


  Future<void> _updateChild(
      Update event,
      Emitter<ChildAddState> emit,
      ) async {
   _onLoading();
    print("EVNET GROUP EVENT");
    if(_token == "")
      _token =  _getToken();
     File? file;
    String fileName = "";
    if(event.filePath != "" && event.fileName != ""){
    final image = decodeImage(Io.File(event.filePath).readAsBytesSync());
    final thumbnail = copyResize(image!, width: 354, height: 472);
    Directory directory = await getApplicationDocumentsDirectory();
    String myPath = directory.path;
    file = Io.File('$myPath/test.jpg')
      ..writeAsBytesSync(encodePng(thumbnail));
    print("path: " + file.path);
    print(file.lengthSync());
    fileName = file.path.split('/').last;
    }
    try {
      bool code = await _service.patchChild(event.model, _token, file == null ? "" : file.path, fileName, event.childId);
      if(code){
        showToast(MyWords.successfully_changed.tr(), Colors.green);
       Navigator.pop(context);
       Navigator.pop(context);
      }
    }catch(e){
      Navigator.pop(context);
      print(e.toString());
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          showToast(MyWords.server_error.tr(), Colors.red); //  emit(Error(error: MyWords.server_error.tr()));
        }
        else {
          showToast(MyWords.undefiend_error.tr(), Colors.red); //  emit(Error(error: MyWords.undefiend_error.tr()));
        }
      }
      else
        showToast(MyWords.undefiend_error.tr(), Colors.red); //  emit(Error(error: MyWords.undefiend_error.tr()));
    }
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



  Future<void> _getInfo(
      LoadInfo event,
      Emitter<ChildAddState> emit,
      ) async {
      emit(ChildAddLoading());
    if(_token == "")
      _token =  _getToken();
    print("TOKEN: " + _token.toString());
      late List<String> listGroup = [];
      late List<int> listGroupId = [];
    try {
      if(listClassId.length == 0) {
        _classModel = await _service.getChildClass(_token);
        for (int i = 0; i < _classModel.results.length; i++) {
          listClass.add(_classModel.results[i].title);
          listClassId.add(_classModel.results[i].id);
        }
      }
      _childInfoModel = await _service.getChildInfo(_token, event.id);
      _groupModel = await _service.getChildGroup(_token, _childInfoModel.childClass.id);
      for (int i = 0; i < _groupModel.list.length; i++) {
        listGroup.add(_groupModel.list[i].title);
        listGroupId.add(_groupModel.list[i].id);
      }
      emit(ChildInfoLoaded(model: _childInfoModel, listClass: listClass, idClass: listClassId, listGroup: listGroup, idGroup: listGroupId));
    }catch(e){
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(ChildAddError(error: MyWords.server_error.tr()));
        }
        else {
          emit(ChildAddError(error: MyWords.undefiend_error.tr()));
        }
      }
    }
  }


  Future<void> _getInfoUpdateGroup(
      UpdateGroup event,
      Emitter<ChildAddState> emit,
      ) async {
    emit(ChildUpdateLoading(idClass: listClassId, listClass: listClass, model: _childInfoModel));
    if(_token == "")
      _token =  _getToken();
    print("TOKEN: " + _token.toString());
    late List<String> listGroup = [];
    late List<int> listGroupId = [];
    try {
      _groupModel = await _service.getChildGroup(_token, event.classId);
      for (int i = 0; i < _groupModel.list.length; i++) {
        listGroup.add(_groupModel.list[i].title);
        listGroupId.add(_groupModel.list[i].id);
      }
      emit(ChildInfoLoaded(model: _childInfoModel, listClass: listClass, idClass: listClassId, listGroup: listGroup, idGroup: listGroupId));
    }catch(e){
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(ChildAUpdateError(model: _childInfoModel, listClass: listClass, idClass: listClassId, error: MyWords.server_error.tr()));
        }
        else {
          emit(ChildAUpdateError(model: _childInfoModel, listClass: listClass, idClass: listClassId, error: MyWords.undefiend_error.tr()));
        }
      }
    }
  }

  String _getToken(){
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }
}
