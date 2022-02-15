part of 'receiver_bloc.dart';

@immutable
abstract class ReceiverEvent {}

class BottomNavEvent extends ReceiverEvent {
  final String next;
  BottomNavEvent({required this.next});
}

class HistoryEvent extends ReceiverEvent {
  bool isConnect;

  HistoryEvent({required this.isConnect});
}

class NextEvent extends ReceiverEvent {}