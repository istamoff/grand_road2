part of 'info_bloc.dart';

@immutable
abstract class InfoState {}

class InfoInitial extends InfoState {}


class InfoLoading extends InfoState {}

class InfoLoaded extends InfoState {}

class InfoError extends InfoState {}