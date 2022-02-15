part of 'camera_bloc.dart';

@immutable
abstract class CameraState {}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraError extends CameraState {
  final String error;

  CameraError({required this.error});
}

class CameraNoInformationState extends CameraState {}

class CameraNoInternet extends CameraState {}

class CameraSuccess extends CameraState {}