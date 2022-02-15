part of 'goout_bloc.dart';

@immutable
abstract class GooutEvent {}

class BottomNavEvent extends GooutEvent {
  final String next;
  BottomNavEvent({required this.next});
}

class HistoryEvent extends GooutEvent {
  bool isConnect;

  HistoryEvent({required this.isConnect});
}

class NextEvent extends GooutEvent {}