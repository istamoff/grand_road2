part of 'child_document_bloc.dart';

@immutable
abstract class ChildDocumentState {}

class ChildDocumentInitial extends ChildDocumentState {}

class ChildDocumentLoading extends ChildDocumentState {}

class ChildDocumentSaveLoading extends ChildDocumentState {
  final  List<String> listDrop;
  final List<int> listId;
  ChildDocumentSaveLoading({required this.listDrop, required this.listId});
}

class ChildDocumentLoaded extends ChildDocumentState {
   final  List<String> listDrop;
   final List<int> listId;

   ChildDocumentLoaded({required this.listDrop, required this.listId});
}

class ChildDocumentError extends ChildDocumentState {
  final String error;

  ChildDocumentError({required this.error});
}

class SaveLoaded extends ChildDocumentState {
  final  List<String> listDrop;
  final List<int> listId;

  SaveLoaded({required this.listDrop, required this.listId});
}