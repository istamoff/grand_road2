part of 'nurse_bloc.dart';

@immutable
abstract class NurseState {}

class NurseInitial extends NurseState {}

class NurseLoading extends NurseState {}

class NurseLoaded extends NurseState {
  final NurseModel model;
  bool isDialog;

  NurseLoaded({required this.model,this.isDialog = true});
}
class NurseNoInfo extends NurseState{}

class NurseError extends NurseState {
  final String error;


  NurseError({required this.error});
}

class NurseServerError extends NurseState{}

class BottomLoading extends NurseState {
  final NurseModel model;

  BottomLoading({required this.model});
}

