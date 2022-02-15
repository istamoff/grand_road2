part of 'child_document_bloc.dart';

@immutable
abstract class ChildDocumentEvent {}

class DocumentType extends ChildDocumentEvent {}

class Save extends ChildDocumentEvent{
  final int fileType, objectId;
  final String filePath, fileName;

  Save({required this.fileType, required this.fileName, required this.filePath, required this.objectId});
}
