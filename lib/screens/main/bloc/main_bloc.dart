import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unikids_uz/db/sqlite_helper.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/db_model.dart';
import 'package:unikids_uz/model/hive/role_data/role_data_model.dart';
import 'package:unikids_uz/model/lang_status_model.dart';
import 'package:unikids_uz/model/nurse_model.dart';
import 'package:unikids_uz/model/response_model.dart';
import 'package:unikids_uz/model/status_model.dart';
import 'package:unikids_uz/model/teacher_go_out_model.dart';
import 'package:unikids_uz/model/teacher_receiver_model.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/info/bloc/info_bloc.dart';
import 'package:unikids_uz/screens/info/info_screen.dart';
import 'package:unikids_uz/screens/info/info_teacher_screen.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/model/nurse_model.dart';
import 'package:unikids_uz/model/teacher_go_out_model.dart';
import 'package:unikids_uz/model/teacher_receiver_model.dart';
import 'package:unikids_uz/utils/words.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final BuildContext context;
  final MyService _service = locator.get<MyService>();
  final DatabaseHelper _db = locator.get<DatabaseHelper>();
  InfoModel _model = InfoModel.empty();

  // TeacherReceiverModel _receiverModel = TeacherReceiverModel.empty();
  // TeacherGoOutModel _outModel = TeacherGoOutModel.empty();
  late MedicStatusModel _statusModel;
  String token = "";

  MainBloc({required this.context}) : super(MainInitial()) {
    on<MainEvent>((event, emit) async {
      if (event is MainLoadEvent) await _loadInfo(event, emit);
      if (event is MainTeacherLoadEvent) await _loadTeacherInfo(event, emit);
      if(event is UpdateLang) await _updateLang(event, emit);
    });
  }

  Future<void> _loadInfo(
    MainLoadEvent event,
    Emitter<MainState> emit,
  ) async {
    print("LOAD INFO");
    _onLoading();
    if (!event.isConnect) {
      print("no _load Internet");
      emit(MainNoInternetState());
    } else {
      try {
        token = _getToken();
        _model = await _service.getInfoModel(event.fileName, event.filePath, token);
        print(_model.result[0].firstName);
        _model.result = _model.result.reversed.toList();
       print(_model.result[0].firstName);
        _statusModel = await _service.statusFunc(token);
        //  int id = _model.result.id;
        //    DbModel dbModel = await _db.getChildIdUserInfo(id);
        //  if(dbModel == null)
        //     print("null");
        if (!_model.isSuccess) {
          print("NO found");
          emit(TeacherResponseState(code: 404));
        }
        else
          _openSceen(_model, _statusModel);
      } catch (e) {
        print(e.toString());
        emit(TeacherResponseState(code: 500));
      }
    }
  }


  Future<void> _loadTeacherInfo(
    MainTeacherLoadEvent event,
    Emitter<MainState> emit,
  ) async {
    _onLoading();
      token = _getToken();
      print("rabotaet");
      try {
        if (event.comeIn == 0) {
          print("Rabota event.comeIn");
          int statusCode  = await _service.postTeacherComeIn(
              event.filePath, event.fileName, token);
         emit(TeacherResponseState(code: statusCode));
        } else {
          token = _getToken();
          _model = await _service.getInfoModel(
              event.fileName, event.filePath, token);
          _statusModel = await _service.statusFunc(token);
          _openTeacherSceen(_model, _statusModel);
        }
      } catch (e) {
        emit(TeacherResponseState(code: 500));
      }
  }

  Future<void> _updateLang(
    UpdateLang event,
    Emitter<MainState> emit,
  ) async {
    token = _getToken();
    print("rabotaet");
    try {
      final box = await Hive.openBox('db');
      RoleDataModel model = token != "" ? box.getAt(0) : RoleDataModel.empty();
      int status = await _service.patchLang(token, event.lang, model.id);
      if(status == 200){
        RxBus.post(
          LangStatusModel(
              lang: event.lang
          ),
          tag: "EVENT_LANG",
        );
      }
    } catch (e) {
      print("Catch " + e.toString());
    }
  }


  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: MyColors.baseSecondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
                child:
                    CircularProgressIndicator(color: MyColors.baseLightColor)),
          ),
        );
      },
    );
  }

  _openSceen(InfoModel model, MedicStatusModel statusModel) {
    List<StatusModel> list = statusModel.list;
    Navigator.pop(context);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        builder: (context) {
          return ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: InfoScreen.screen(model, list));
        });
  }

  _openTeacherSceen(InfoModel model, MedicStatusModel statusModel) {
    List<StatusModel> list = statusModel.list;
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        builder: (context) {
          print("_openScren");
          return ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: InfoTeacherScreen.screen(model, list));
        });
  }

  String _getToken() {
    var box = Hive.box('db');
    String token = box.get('token');
    return token;
  }
}
