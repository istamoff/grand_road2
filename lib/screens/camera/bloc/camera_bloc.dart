import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/picture_error_model.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/utils/words.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  String token = "";
  final MyService _service = locator.get<MyService>();

  CameraBloc() : super(CameraInitial()) {
    on<CameraEvent>((event, emit) async {
      if(event is LoadEvent)
        await _loadInfo(event, emit);
    });
  }


  Future<void> _loadInfo(
      LoadEvent event,
      Emitter<CameraState> emit,
      ) async {
   emit(CameraLoading());
    if (!event.isConnect) {
      emit(CameraNoInternet());
    } else {
      try {
        token = _getToken();
       PictureErrorModel model = await _service.patchPupilUpdate(token, event.filePath, event.fileName, event.id);
        //  int id = _model.result.id;
        //    DbModel dbModel = await _db.getChildIdUserInfo(id);
        //  if(dbModel == null)
        //     print("null");
        if(model.message.uz == "")
        emit(CameraSuccess());
        else{
          emit(CameraError(error: model.message.uz));
        }
      } catch (e) {
        print(e.toString());
       emit(CameraError(error: MyWords.undefiend_error.tr()));
      }
    }
  }

  String _getToken(){
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }

}
