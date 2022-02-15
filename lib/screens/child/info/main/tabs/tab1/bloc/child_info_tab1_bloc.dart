import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/child/child_in_out_model.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:unikids_uz/utils/words.dart';

part 'child_info_tab1_event.dart';
part 'child_info_tab1_state.dart';

class ChildInfoTab1Bloc extends Bloc<ChildInfoTab1Event, ChildInfoTab1State> {
  late ChildInOutModel _childInOutModel;
  final MyService _service = locator.get<MyService>();
  String next = "";
  
  
  ChildInfoTab1Bloc() : super(ChildInfoTab1Initial()) {
    on<ChildInfoTab1Event>((event, emit) async {
      if(event is HistoryEvent)
        await  _historyInfo(event, emit);
      else if(event is NextEvent)
      await _nextInfo(event, emit);
    });
  }



  Future<void> _historyInfo(
      HistoryEvent event,
      Emitter<ChildInfoTab1State> emit,
      ) async {
    if(!event.isConnect){
      emit(ChildInfoTab1NoInfo(txt:  MyWords.no_internet_connection.tr()));
    }
    else {
      emit(ChildInfoTab1Loading());
      try {
        String token = _getToken();
        _childInOutModel = await _service.getChildInOutModel(event.id, token);
        if (_childInOutModel.results.length == 0)
          emit(ChildInfoTab1NoInfo(txt:  MyWords.no_info.tr()));
        else {
          next = _childInOutModel.next;
          emit(ChildInfoTab1Loaded(model: _childInOutModel, isDialog: false));
        }
      } catch (e) {
        if(e is DioError){
          if(e.type == DioErrorType.connectTimeout){
            emit(ChildInfoTab1Error(error:  MyWords.undefiend_error.tr())); // throw Exception("Connection  Timeout Exception");
          }
          emit(ChildInfoTab1Error(error:  MyWords.undefiend_error.tr()));
        }
        else
          emit(ChildInfoTab1Error(error:  MyWords.undefiend_error.tr()));
      }
    }
  }


  Future<void> _nextInfo(
      NextEvent event,
      Emitter<ChildInfoTab1State> emit,
      ) async {
    emit(BottomLoading(model: _childInOutModel));
    if(next == "")
      emit(ChildInfoTab1Loaded(model: _childInOutModel));
    else {
      try {
        ChildInOutModel model;
        String token = _getToken();
        model = await _service.getChildInOutNextModel(token, next);
        _childInOutModel.count = model.count;
        _childInOutModel.next = model.next;
        _childInOutModel.previous = model.previous;
        _childInOutModel.results.addAll(model.results);
        next = model.next;
        emit(ChildInfoTab1Loaded(model: _childInOutModel));
      } catch (e) {
        emit(ChildInfoTab1Error(error:  MyWords.no_info.tr()));
      }
    }
  }

  String _getToken(){
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }
}
