import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/nurse_model.dart';
import 'package:unikids_uz/model/nurse_model.dart';
import 'package:unikids_uz/model/nurse_model.dart';
import 'package:unikids_uz/screens/main/bloc/main_bloc.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/utils/words.dart';

part 'nurse_event.dart';

part 'nurse_state.dart';

class NurseBloc extends Bloc<NurseEvent, NurseState> {
  late NurseModel _nurseModel;
  final MyService _service = locator.get<MyService>();
  String next = "";

  NurseBloc() : super(NurseInitial()) {
    on<NurseEvent>((event, emit) async {
      if (event is HistoryEvent)
        await _historyInfo(event, emit);
      else if (event is NextEvent) await _nextInfo(event, emit);
    });
  }

  Future<void> _historyInfo(
    HistoryEvent event,
    Emitter<NurseState> emit,
  ) async {
    if (!event.isConnect) {
      emit(NurseError(error: MyWords.server_error.tr()));
    } else {
      emit(NurseLoading());
      try {
        String token = _getToken();
        _nurseModel = await _service.getHistoryNurseModel(token);
        if(_nurseModel.results.length == 0){
          emit(NurseNoInfo());
        }
        else {
          next = _nurseModel.next;
          emit(NurseLoaded(model: _nurseModel, isDialog: false));
        }
      } catch (e) {
        if(e is DioError){
          if(e.response!.statusCode! >= 500)
            emit(NurseServerError());
          else
          emit(NurseError(error: MyWords.undefiend_error.tr()));
        }
        emit(NurseError(error: MyWords.no_info.tr()));
      }
    }
  }

  //Нет соединения с интернетом
  Future<void> _nextInfo(
    NextEvent event,
    Emitter<NurseState> emit,
  ) async {
    emit(BottomLoading(model: _nurseModel));
    print("NEXT bottom :         " + next);
    if (next == "")
      emit(NurseLoaded(model: _nurseModel));
    else {
      try {
        NurseModel model;
        String token = _getToken();
        model = await _service.getHistoryNurseNextModel(token, next);
        _nurseModel.count = model.count;
        _nurseModel.next = model.next;
        _nurseModel.previous = model.previous;
        _nurseModel.results.addAll(model.results);
        next = model.next;
        emit(NurseLoaded(model: _nurseModel));
      } catch (e) {
        emit(NurseError(error: e.toString()));
      }
    }
  }

  String _getToken() {
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }
}
