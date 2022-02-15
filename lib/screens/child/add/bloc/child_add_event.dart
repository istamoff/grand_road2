part of 'child_add_bloc.dart';

@immutable
abstract class ChildAddEvent {}

class LoadClass extends ChildAddEvent {}

class LoadGroup extends ChildAddEvent {
   int id;

   LoadGroup({required this.id});
}

class Load extends ChildAddEvent {

}

class Add extends ChildAddEvent{
   final LocalChildAddModel model;
   final String filePath, fileName;

   Add({required this.model, required this.fileName, required this.filePath});
}

class LoadInfo extends ChildAddEvent {
   int id;
   LoadInfo({required this.id});
}

class UpdateGroup extends ChildAddEvent {
  int classId;
  UpdateGroup({required this.classId});
}

class Update extends ChildAddEvent{
  final LocalChildAddModel model;
  final String filePath, fileName;
  final int childId;

  Update({required this.model, required this.fileName, required this.filePath, required this.childId});
}