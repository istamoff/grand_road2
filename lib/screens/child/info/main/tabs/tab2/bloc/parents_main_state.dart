part of 'parents_main_bloc.dart';

@immutable
abstract class ParentsMainState {}

class ParentsMainInitial extends ParentsMainState {}


class ParentsMainLoading extends ParentsMainState {}

class ParentsMainLoaded extends ParentsMainState {
  final ParentsModel model;
  bool isDialog;

  ParentsMainLoaded({required this.model,this.isDialog = true});
}


 class DeleteLoaded extends ParentsMainState{
   final ParentsModel model;
   DeleteLoaded({required this.model});
 }



class ParentsMainError extends ParentsMainState {
  final String error;

  ParentsMainError({required this.error});
}

class BottomLoading extends ParentsMainState {
  final ParentsModel model;

  BottomLoading({required this.model});
}

class ParentsMainNoInfo extends ParentsMainState {
  final String txt;

  ParentsMainNoInfo({required this.txt});
}


class ParentsMainDeleteError extends ParentsMainState {
  final ParentsModel model;

  ParentsMainDeleteError({required this.model});
}