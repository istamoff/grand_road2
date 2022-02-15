import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/hive/role_data/role_data_model.dart';
import 'package:unikids_uz/model/login_model.dart';
import 'package:unikids_uz/model/url_model.dart';
import 'package:unikids_uz/screens/main/main_admin_screen.dart';
import 'package:unikids_uz/screens/main/main_nurse_screen.dart';
import 'package:unikids_uz/screens/main/main_teacher_screen.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  BuildContext context;
  final MyService _service = locator.get<MyService>();
  late RoleDataModel _model;
  late List<String> list = [];
  late List<String> baseUrl = [];
 // late UrlModel _gardenModel;
 // late String _baseUrl = "";

  LoginBloc({required this.context}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if(event is SignInEvent)
        await _loadFunc(event, emit);
    });

  }




  Future<void> _loadFunc(
      SignInEvent event,
      Emitter<LoginState> emit,
      ) async {
      emit(LoginLoading());
      try {
       _model = await _service.loginFunc(event.username, event.password);
        var box = Hive.box('db');
        String permission = box.get("permission");
        String token = _getToken();

       await _service.patchLang(token, event.lang, _model.id);
        if(permission == "nurse_all") {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainNurseScreen.screen(event.camera, _model, permission)),
        );
        } else if(permission == "teacher_all") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainTeacherScreen.screen(event.camera, _model, permission)));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainAdminScreen.screen(token, event.camera, _model, permission)));
        }
      }catch(e){
        if(e is DioError){
          if(e.response!.statusCode == 401){
            emit(LoginFail());
            Fluttertoast.showToast(
                msg: MyWords.user_not_exist.tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
          else if(e.response!.statusCode! >= 500){
            Fluttertoast.showToast(
                msg: MyWords.server_error.tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
          else {
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
        print("login: error: " + e.toString());
        emit(LoginFail());
      }
  }




  String _getToken(){
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }
}
