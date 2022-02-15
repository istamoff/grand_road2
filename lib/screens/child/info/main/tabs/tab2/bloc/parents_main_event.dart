part of 'parents_main_bloc.dart';

@immutable
abstract class ParentsMainEvent {}


class Load extends ParentsMainEvent {}

class BottomNavEvent extends ParentsMainEvent {
  final String next;
  BottomNavEvent({required this.next});
}

class HistoryEvent extends ParentsMainEvent {
  bool isConnect;
  int id;

  HistoryEvent({required this.isConnect, required this.id});
}

class NextEvent extends ParentsMainEvent {}


class Delete extends ParentsMainEvent{
   int id;
   int childId;
   Delete({required this.id, required this.childId});
}