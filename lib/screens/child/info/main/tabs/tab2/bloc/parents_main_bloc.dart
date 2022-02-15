import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/parents/parents_model.dart';
import 'package:unikids_uz/service/parents/parents_service.dart';
import 'package:unikids_uz/utils/words.dart';

part 'parents_main_event.dart';
part 'parents_main_state.dart';

class ParentsMainBloc extends Bloc<ParentsMainEvent, ParentsMainState> {
  late ParentsModel _parentsModel;
  final ParentsService _service = locator.get<ParentsService>();
  String next = "";
  String token= "";

  ParentsMainBloc() : super(ParentsMainInitial()) {
    on<ParentsMainEvent>((event, emit) async {
      if(event is HistoryEvent)
        await  _historyInfo(event, emit);
      else if(event is NextEvent)
      await  _nextInfo(event, emit);
      else if(event is Delete)
        await  _deleteInfo(event, emit);
      // TODO: implement event handler
    });
  }
  
  Future<void> _historyInfo(
      HistoryEvent event,
      Emitter<ParentsMainState> emit,
      ) async {
    if(!event.isConnect){
      emit(ParentsMainNoInfo(txt:  MyWords.no_internet_connection.tr()));
    }
    else {
      emit(ParentsMainLoading());
      try {
        if(token == "")
        token = _getToken();
        _parentsModel = await _service.getParentsModel(event.id, token);
        if (_parentsModel.results.length == 0)
          emit(ParentsMainNoInfo(txt:  MyWords.no_info.tr()));
        else {
          next = _parentsModel.next;
          emit(ParentsMainLoaded(model: _parentsModel, isDialog: false));
        }
      } catch (e) {
        if(e is DioError){
          if(e.type == DioErrorType.connectTimeout){
            emit(ParentsMainError(error:  MyWords.undefiend_error.tr())); // throw Exception("Connection  Timeout Exception");
          }
          emit(ParentsMainError(error:  MyWords.undefiend_error.tr()));
        }
        else
          emit(ParentsMainError(error:  MyWords.undefiend_error.tr()));
      }
    }
  }


  Future<void> _nextInfo(
      NextEvent event,
      Emitter<ParentsMainState> emit,
      ) async {
    emit(BottomLoading(model: _parentsModel));
    if(next == "")
      emit(ParentsMainLoaded(model: _parentsModel));
    else {
      try {
        ParentsModel model;
        if(token == "")
        token = _getToken();
        model = await _service.getParentsNextModel(token, next);
        _parentsModel.count = model.count;
        _parentsModel.next = model.next;
        _parentsModel.previous = model.previous;
        _parentsModel.results.addAll(model.results);
        next = model.next;
        emit(ParentsMainLoaded(model: _parentsModel));
      } catch (e) {
        emit(ParentsMainError(error:  MyWords.no_info.tr()));
      }
    }
  }


  Future<void> _deleteInfo(
      Delete event,
      Emitter<ParentsMainState> emit,
      ) async {
      emit(ParentsMainLoading());
      int statusCode = 0;
      try {
        if(token == "")
        token = _getToken();
        int statusCode = await _service.deleteParents(token, event.id);
        if(statusCode == 204) {
          _parentsModel = await _service.getParentsModel(event.childId, token);
          if (_parentsModel.results.length == 0)
            emit(ParentsMainNoInfo(txt:  MyWords.no_info.tr()));
          else {
            next = _parentsModel.next;
            print("Rabota delete info");
            emit(DeleteLoaded(model: _parentsModel));
          }
        }
      } catch (e) {
        print("_deleteInfo catch");
        if(e is DioError){
          if(e.type == DioErrorType.connectTimeout){
            _showToast(Colors.red, MyWords.server_error.tr());
          }
          else
         _showToast(Colors.red,  MyWords.undefiend_error.tr());

        }
        else
          _showToast(Colors.red, MyWords.undefiend_error.tr());
        }

  }

  _showToast(Color color, String txt){
    Fluttertoast.showToast(
        msg: MyWords.undefiend_error.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  String _getToken(){
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }
}
