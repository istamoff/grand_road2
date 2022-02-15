import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/teacher_go_out_model.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/utils/words.dart';

part 'goout_event.dart';
part 'goout_state.dart';

class GooutBloc extends Bloc<GooutEvent, GooutState> {
  late TeacherGoOutModel _goOutModel;
  final MyService _service = locator.get<MyService>();
  String next = "";
  
  GooutBloc() : super(GooutInitial()) {
    on<GooutEvent>((event, emit) async {
      if(event is HistoryEvent)
        await  _historyInfo(event, emit);
      else if(event is NextEvent)
      await _nextInfo(event, emit);
    });
  }


  Future<void> _historyInfo(
      HistoryEvent event,
      Emitter<GooutState> emit,
      ) async {
    emit(GooutLoading());
    print("rabotaet Goout");
    if(!event.isConnect){
      emit(GooutNoInformation());
    }else {
      try {
        String token = _getToken();
        _goOutModel = await _service.getHistoryGoOutModel(token);
        if (_goOutModel.results.length == 0)
          emit(GooutNoInformation());
        else {
          next = _goOutModel.next;
          print("NEXT:         " + next);
          emit(GooutLoaded(model: _goOutModel, isDialog: false));
        }
      } catch (e) {
        if(e is DioError){
          if(e.response!.statusCode! >= 500)
            emit(GooutServerError());
          else
            emit(GooutUnDefinedError());
        }
        emit(GooutNoInformation());
      }
    }
  }


  Future<void> _nextInfo(
      NextEvent event,
      Emitter<GooutState> emit,
      ) async {
    emit(BottomLoading(model: _goOutModel));
    print("NEXT bottom :         " + next);
    if(next == "")
      emit(GooutLoaded(model: _goOutModel));
    else {
      print("rabotaet Goout NEXTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
      try {
        print("rabotaet Goout try NEXTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
        TeacherGoOutModel model;
        String token = _getToken();
        model = await _service.getHistoryTeacherGoOutNextModel(token, next);
        _goOutModel.count = model.count;
        _goOutModel.next = model.next;
        _goOutModel.previous = model.previous;
        _goOutModel.results.addAll(model.results);
        next = model.next;
        print(_goOutModel.results.length.toString() + "" + model.count.toString());
        print("rabotaet Goout last NEXTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
        emit(GooutLoaded(model: _goOutModel));
      } catch (e) {
        if(e is DioError){
          if(e.response!.statusCode! >= 500)
            emit(GooutServerError());
          else
            emit(GooutUnDefinedError());
        }
        emit(GooutNoInformation());
      }
    }
  }

  String _getToken(){
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }
}
