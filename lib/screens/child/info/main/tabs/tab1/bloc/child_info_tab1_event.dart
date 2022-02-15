part of 'child_info_tab1_bloc.dart';

@immutable
abstract class ChildInfoTab1Event {}

class Load extends ChildInfoTab1Event {}

class BottomNavEvent extends ChildInfoTab1Event {
  final String next;
  BottomNavEvent({required this.next});
}

class HistoryEvent extends ChildInfoTab1Event {
  bool isConnect;
  int id;

  HistoryEvent({required this.isConnect, required this.id});
}

class NextEvent extends ChildInfoTab1Event {}
