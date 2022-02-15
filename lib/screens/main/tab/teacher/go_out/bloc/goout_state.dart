part of 'goout_bloc.dart';

@immutable
abstract class GooutState {}

class GooutInitial extends GooutState {}

class GooutLoading extends GooutState {}

class GooutLoaded extends GooutState {
  final TeacherGoOutModel model;
  bool isDialog;

  GooutLoaded({required this.model,this.isDialog = true});
}

class GooutUnDefinedError extends GooutState {}

class GooutServerError extends GooutState {}

class GooutNoInformation extends GooutState{}

class BottomLoading extends GooutState {
  final TeacherGoOutModel model;

  BottomLoading({required this.model});
}

