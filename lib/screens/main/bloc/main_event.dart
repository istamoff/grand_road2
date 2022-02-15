part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class MainLoadEvent extends MainEvent {
   final isConnect, fileName, filePath;

   MainLoadEvent({this.isConnect, this.filePath, this.fileName});
}

class MainTeacherLoadEvent extends MainEvent {
   bool isConnect;
   String fileName, filePath;
   int comeIn;
   MainTeacherLoadEvent({required this.isConnect, required this.filePath, required this.fileName, required this.comeIn});
}

class UpdateLang extends MainEvent{
   String lang;

   UpdateLang({required this.lang});
}

