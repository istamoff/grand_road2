part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class MainLoadingState extends MainState {}

class MainErrorState extends MainState {
  final String error;

  MainErrorState({required this.error});
}

class MainNoInformationState extends MainState {}

class MainServerErrorState extends MainState {}

class MainNoInternetState extends MainState {}

class MainNurseLoadedState extends MainState {
  NurseModel model;

  MainNurseLoadedState({required this.model});
}

class MainTeacherLoadedState extends MainState {
  TeacherGoOutModel modelGoOut;
  TeacherReceiverModel modelReceiverModel;

  MainTeacherLoadedState({required this.modelGoOut, required this.modelReceiverModel});
}

class UpdateSuccess extends MainState{}


class TeacherResponseState extends MainState {
  final int code;

  TeacherResponseState({required this.code});
}

