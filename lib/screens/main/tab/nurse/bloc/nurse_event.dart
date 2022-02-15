part of 'nurse_bloc.dart';

@immutable
abstract class NurseEvent {}

class BottomNavEvent extends NurseEvent {
  final String next;
  BottomNavEvent({required this.next});
}

class HistoryEvent extends NurseEvent {
   bool isConnect;

   String lang;

   HistoryEvent({required this.isConnect, this.lang = ""});
}

class NextEvent extends NurseEvent {}

