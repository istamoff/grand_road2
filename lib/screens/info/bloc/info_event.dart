part of 'info_bloc.dart';

@immutable
abstract class InfoEvent {}

class InfoLoadEvent extends InfoEvent{
  int child;
  double temperature;
  int come_in_person;
  int status;

  InfoLoadEvent({required this.child, required this.temperature, required this.come_in_person, required this.status});
}

class InfoTeacherEvent extends InfoEvent{
  int child;
  int go_out_person;

  InfoTeacherEvent({required this.child, required this.go_out_person});
}

