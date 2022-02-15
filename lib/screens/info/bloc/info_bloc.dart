import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/utils/words.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  BuildContext context;

  final MyService _service = locator.get<MyService>();

  InfoBloc({required this.context}) : super(InfoInitial()) {
    on<InfoEvent>((event, emit) async {
      if(event is InfoLoadEvent) {
        await _loadFunc(event, emit);
      }
      if(event is InfoTeacherEvent)
        await  _loadTeacherMethod(event, emit);
    });
  }

  Future<void> _loadFunc(
      InfoLoadEvent event,
      Emitter<InfoState> emit,
      ) async {
    emit(InfoLoading());
    try {
      double temperatura = double.parse(event.temperature.toString().substring(0, 4));
     bool response  = await _service.createChildJournal(event.child, temperatura, event.status, event.come_in_person);
      if(response) {
        Fluttertoast.showToast(
            msg: MyWords.add_list.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pop(context);
      }
      else {
          Fluttertoast.showToast(
              msg: MyWords.error_repeat.tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.pop(context);
        }

    }catch(e){
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
  }

  Future<void> _loadTeacherMethod(
      InfoTeacherEvent event,
      Emitter<InfoState> emit,
      ) async {
    print("loading");
    emit(InfoLoading());
    try {
      // double temperatura = double.parse(event.temperature.toString().substring(0, 4));
       bool response  = await _service.postTeacherGoOut(event.child, event.go_out_person);
      if(response) {
        Fluttertoast.showToast(
            msg: MyWords.add_list.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pop(context);
      }
      else {
        Fluttertoast.showToast(
            msg: MyWords.add_list.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pop(context);
      }
    }catch(e){
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
  }
}
