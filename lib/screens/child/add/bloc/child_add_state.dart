part of 'child_add_bloc.dart';

@immutable
abstract class ChildAddState {}

class ChildAddInitial extends ChildAddState {}

class ChildAddLoading extends ChildAddState {}

class ChildUpdateLoading extends ChildAddState {
  final ChildInfoModel model;
  final List<String> listClass;
  final List<int> idClass;

  ChildUpdateLoading({required this.listClass, required this.idClass, required this.model});
}

class ChildAddLoaded extends ChildAddState {
   final List<String> list;
   final List<int> id;
   ChildAddLoaded({required this.list, required this.id});
}

class ChildAddGroupLoaded extends ChildAddState {
  final List<String> list;
  final List<int> id;
  ChildAddGroupLoaded({required this.list, required this.id});
}

class ChildInfoLoaded extends ChildAddState{
   final ChildInfoModel model;
   final List<String> listGroup;
   final List<int> idGroup;
   final List<String> listClass;
   final List<int> idClass;

   ChildInfoLoaded({required this.model, required this.listGroup, required this.idGroup, required this.listClass, required this.idClass});
}

class ChildAddError extends ChildAddState {
  final String error;
  ChildAddError({required this.error});
}


class ChildAUpdateError extends ChildAddState {
  final ChildInfoModel model;
  final List<String> listClass;
  final List<int> idClass;
  final String error;
  ChildAUpdateError({required this.model, required this.listClass, required this.idClass, required this.error});
}

class Error extends ChildAddState {
  final String error;
  Error({required this.error});
}


class Done extends ChildAddState {}

class DoneLoading extends ChildAddState {}

