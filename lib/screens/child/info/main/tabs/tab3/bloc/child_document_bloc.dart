import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/parents/document_type_model.dart';
import 'package:unikids_uz/service/parents/parents_service.dart';
import 'package:unikids_uz/utils/words.dart';
import 'dart:io' as Io;

part 'child_document_event.dart';
part 'child_document_state.dart';

class ChildDocumentBloc extends Bloc<ChildDocumentEvent, ChildDocumentState> {
  late String _token = "";
  final ParentsService _service = locator.get<ParentsService>();
  late DocumentTypeModel _documentType = DocumentTypeModel.empty();
  List<String> listDrop = [];
  List<int> listId = [];

  ChildDocumentBloc() : super(ChildDocumentInitial()) {
    on<ChildDocumentEvent>((event, emit) async {
      if(event is DocumentType)
        await  _getInfo(event, emit);
      if(event is Save)
        await _saveChildDocuments(event, emit);
    });
  }

  Future<void> _getInfo(
      DocumentType event,
      Emitter<ChildDocumentState> emit,
      ) async {
    emit(ChildDocumentLoading());
    if(_token == "")
      _token =  _getToken();
    try {
      if(_documentType.results.length == 0)
      _documentType = await _service.getDocumentType(_token);
      for (int i = 0; i < _documentType.count; i++) {
        listDrop.add( _documentType.results[i].title);
        listId.add(_documentType.results[i].id);
      }
      emit(ChildDocumentLoaded(listId: listId, listDrop: listDrop));
    }catch(e){
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(ChildDocumentError(error: MyWords.server_error.tr()));
        }
        else {
          print("ERROR ex");
          emit(ChildDocumentError(error: MyWords.undefiend_error.tr()));
        }
      }
    }
  }


  Future<void> _saveChildDocuments(
      Save event,
      Emitter<ChildDocumentState> emit,
      ) async {
    emit(ChildDocumentSaveLoading(listDrop: listDrop, listId: listId));
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
      bool code = await _service.postDocumenty(_token, file.path,  fileName, event.objectId, event.fileType,);
      if(code){
        emit(SaveLoaded(listDrop: listDrop, listId: listId));
      }
    }catch(e){
      print(e.toString());
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(ChildDocumentError(error: MyWords.server_error.tr()));
        }
        else {
          emit(ChildDocumentError(error: MyWords.undefiend_error.tr()));
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
