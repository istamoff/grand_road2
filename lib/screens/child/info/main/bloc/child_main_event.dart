part of 'child_main_bloc.dart';

@immutable
abstract class ChildMainEvent {}

class Load extends ChildMainEvent {
  int id;
  Load({required this.id});
}

