import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/parents/human_model.dart';
import 'package:unikids_uz/model/parents/local_parent_add_model.dart';
import 'package:unikids_uz/model/parents/relative_type_model.dart';
import 'package:unikids_uz/screens/child/info/main/tabs/tab2/bloc/parents_main_bloc.dart';
import 'package:unikids_uz/service/parents/parents_service.dart';
import 'package:unikids_uz/utils/words.dart';
import 'dart:io' as Io;

part 'parents_add_event.dart';
part 'parents_add_state.dart';

class ParentsAddBloc extends Bloc<ParentsAddEvent, ParentsAddState> {
  late String _token = "";
  final ParentsService _service = locator.get<ParentsService>();
  late ChildGroupModel _list;
  List<String> listDrop = [];
  List<int> listId = [];
  late HumansModel _humansModel;

  ParentsAddBloc() : super(Initial()) {
    on<ParentsAddEvent>((event, emit) async {
      if(event is Load)
        await  _getClassList(event, emit);
      if(event is Add)
        await _addParents(event, emit);
      if(event is Update)
        await _getHuman(event, emit);
      if(event is UpdateBtn)
        await _updateParents(event, emit);
    });
  }

  Future<void> _getClassList(
      Load event,
      Emitter<ParentsAddState> emit,
      ) async {
    print("_GetClassLISTsss");
      emit(Loading());
    if(_token == "")
      _token =  _getToken();
    try {
      _list = await _service.getRelativeParents(_token);
      for (int i = 0; i < _list.list.length; i++) {
        listDrop.add( _list.list[i].title);
        listId.add( _list.list[i].id);
      }
      print(_list.list.length.toString());
      emit(Loaded(listDrop: listDrop, listId: listId));
    }catch(e){
      print(e.toString());
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(Error(error: MyWords.server_error.tr()));
        }
        else {
          emit(Error(error: MyWords.undefiend_error.tr()));
        }
      }
    }
  }

  Future<void> _addParents(
      Add event,
      Emitter<ParentsAddState> emit,
      ) async {
    emit(Loading());
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
      bool code = await _service.postAddParents(event.model, _token, file.path, fileName);
      if(code){
        emit(Done());
      }
    }catch(e){
      print(e.toString());
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(ErrorAdd(error: MyWords.server_error.tr()));
        }
        else {
          emit(ErrorAdd(error: MyWords.undefiend_error.tr()));
        }
      }
    }
  }


  Future<void> _getHuman(
      Update event,
      Emitter<ParentsAddState> emit,
      ) async {
    emit(Loading());
    if(_token == "")
      _token =  _getToken();
    try {
      _list = await _service.getRelativeParents(_token);
      for (int i = 0; i < _list.list.length; i++) {
        listDrop.add( _list.list[i].title);
        listId.add( _list.list[i].id);
      }
      _humansModel = await _service.getHumansModel(event.id, _token);
      print(_list.list.length.toString());
      emit(UpdateLoaded(listDrop: listDrop, listId: listId, model: _humansModel));
    }catch(e){
      print(e.toString() + " getHumans");
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(Error(error: MyWords.server_error.tr()));
        }
        else {
          emit(Error(error: MyWords.undefiend_error.tr()));
        }
      }
    }
  }

  Future<void> _updateParents(
      UpdateBtn event,
      Emitter<ParentsAddState> emit,
      ) async {
    emit(Loading());
    late File? file;
    String fileName = "";
    String filePath = "";
    bool code = false;
    bool isImage = false;
    print("EVNET GROUP EVENT");
    if(_token == "")
      _token =  _getToken();
    if(event.fileName != "") {
      final image = decodeImage(Io.File(event.filePath).readAsBytesSync());
      final thumbnail = copyResize(image!, width: 354, height: 472);
      Directory directory = await getApplicationDocumentsDirectory();
      String myPath = directory.path;
      File file = Io.File('$myPath/test.jpg')
        ..writeAsBytesSync(encodePng(thumbnail));
      filePath = file.path;
      fileName = file.path
          .split('/')
          .last;
      isImage = true;
    }
    try {
      if(isImage)
      code = await _service.patchHumansModel(event.id, _token, event.model,  filePath, fileName);
      else
      code = await _service.patchHumansModel(event.id, _token, event.model, "", "");
      if(code){
        emit(Done());
      }
    }catch(e){
      print(e.toString());
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(ErrorAdd(error: MyWords.server_error.tr()));
        }
        else {
          emit(ErrorAdd(error: MyWords.undefiend_error.tr()));
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
