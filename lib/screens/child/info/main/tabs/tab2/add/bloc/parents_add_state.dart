part of 'parents_add_bloc.dart';

@immutable
abstract class ParentsAddState {}

class Initial extends ParentsAddState {}


class Loading extends ParentsAddState {}

class Error extends ParentsAddState {
  String error;

  Error({required this.error});
}

class ErrorAdd extends ParentsAddState {
  String error;

  ErrorAdd({required this.error});
}


class Loaded extends ParentsAddState {
  final List<String> listDrop;
  final List<int> listId;

 Loaded({required this.listDrop, required this.listId});
}

class Done extends ParentsAddState {}

class UpdateLoaded extends ParentsAddState {
    final HumansModel model;
    final List<String> listDrop;
    final List<int> listId;

    UpdateLoaded({required this.listDrop, required this.listId, required this.model});
}





