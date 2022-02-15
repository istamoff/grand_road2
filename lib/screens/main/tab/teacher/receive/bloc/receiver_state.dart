part of 'receiver_bloc.dart';

@immutable
abstract class ReceiverState {}

class ReceiverInitial extends ReceiverState {}

class ReceiverLoading extends ReceiverState {}

class ReceiverLoaded extends ReceiverState {
  final TeacherReceiverModel model;
  bool isDialog;

  ReceiverLoaded({required this.model,this.isDialog = true});
}

class ReceiverError extends ReceiverState {
  final String error;

  ReceiverError({required this.error});
}

class BottomLoading extends ReceiverState {
  final TeacherReceiverModel model;

  BottomLoading({required this.model});
}

class ReceiverNoInfo extends ReceiverState {
  final String txt;

  ReceiverNoInfo({required this.txt});
}
