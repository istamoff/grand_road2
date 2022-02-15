import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/teacher_receiver_model.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/utils/words.dart';

part 'receiver_event.dart';
part 'receiver_state.dart';

class ReceiverBloc extends Bloc<ReceiverEvent, ReceiverState> {
  late TeacherReceiverModel _receiverModel;
  final MyService _service = locator.get<MyService>();
  String next = "";
  
  ReceiverBloc() : super(ReceiverInitial()) {
    on<ReceiverEvent>((event, emit) async {
      if(event is HistoryEvent)
        await _historyInfo(event, emit);
      else if(event is NextEvent)
      await _nextInfo(event, emit);
    });
  }


  Future<void> _historyInfo(
      HistoryEvent event,
      Emitter<ReceiverState> emit,
      ) async {
    if(!event.isConnect){
      emit(ReceiverNoInfo(txt:  MyWords.no_internet_connection.tr()));
    }
    else {
      emit(ReceiverLoading());
      try {
        String token = _getToken();
        _receiverModel = await _service.getHistoryTeacherReceiverModel(token);
        if (_receiverModel.results.length == 0)
          emit(ReceiverNoInfo(txt:  MyWords.no_info.tr()));
        else {
          next = _receiverModel.next;
          emit(ReceiverLoaded(model: _receiverModel, isDialog: false));
        }
      } catch (e) {
        if(e is DioError){
          if(e.type == DioErrorType.connectTimeout){
            emit(ReceiverError(error:  MyWords.undefiend_error.tr())); // throw Exception("Connection  Timeout Exception");
          }
            emit(ReceiverError(error:  MyWords.undefiend_error.tr()));
        }
        else
          emit(ReceiverError(error:  MyWords.undefiend_error.tr()));
      }
    }
  }


  Future<void> _nextInfo(
      NextEvent event,
      Emitter<ReceiverState> emit,
      ) async {
    emit(BottomLoading(model: _receiverModel));
    if(next == "")
      emit(ReceiverLoaded(model: _receiverModel));
    else {
      try {
        TeacherReceiverModel model;
        String token = _getToken();
        model = await _service.getHistoryTeacherReceiverNextModel(token, next);
        _receiverModel.count = model.count;
        _receiverModel.next = model.next;
        _receiverModel.previous = model.previous;
        _receiverModel.results.addAll(model.results);
        next = model.next;
        emit(ReceiverLoaded(model: _receiverModel));
      } catch (e) {
        emit(ReceiverError(error:  MyWords.no_info.tr()));
      }
    }
  }

  String _getToken(){
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }
}
