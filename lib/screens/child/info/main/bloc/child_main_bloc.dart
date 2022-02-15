import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:unikids_uz/di/locator.dart';
import 'package:unikids_uz/model/child/child_documents_model.dart';
import 'package:unikids_uz/model/child/child_in_out_model.dart';
import 'package:unikids_uz/model/child/child_parents_model.dart';
import 'package:unikids_uz/model/child_info_model.dart';
import 'package:unikids_uz/service/service.dart';
import 'package:unikids_uz/utils/words.dart';

part 'child_main_event.dart';
part 'child_main_state.dart';

class ChildMainBloc extends Bloc<ChildMainEvent, ChildMainState> {
  final MyService _service = locator.get<MyService>();
  late ChildInfoModel _childInfoModel = ChildInfoModel.empty();
  late String _token = "";


  ChildMainBloc() : super(ChildMainInitial()) {
    on<ChildMainEvent>((event, emit) async {
      if(event is Load)
        await _getInfo(event, emit);
    });
  }


  Future<void> _getInfo(
      Load event,
      Emitter<ChildMainState> emit,
      ) async {
    emit(Loading());
    if(_token == "")
      _token =  _getToken();
    try {
      _childInfoModel = await _service.getChildInfo(_token, event.id);
      emit(LoadedChildInfo(childInfoModel: _childInfoModel));
    }catch(e){
      if(e is DioError){
        if(e.response!.statusCode! >= 500){
          emit(Error(error: MyWords.server_error.tr()));
        }
        else {
          print("ERROR ex");
          emit(Error(error: MyWords.undefiend_error.tr()));
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
