part of 'parents_add_bloc.dart';

@immutable
abstract class ParentsAddEvent {}


class Load extends ParentsAddEvent {}


class Add extends ParentsAddEvent{
  final LocalParentAddModel model;
  final String filePath, fileName;

  Add({required this.model, required this.fileName, required this.filePath});
}

class Update extends ParentsAddEvent{
   final id;
   Update({required this.id});
}

class UpdateBtn extends ParentsAddEvent{
  final id;
  final LocalParentAddModel model;
  final String filePath, fileName;
  UpdateBtn({required this.id, required this.model, required this.fileName, required this.filePath});
}
