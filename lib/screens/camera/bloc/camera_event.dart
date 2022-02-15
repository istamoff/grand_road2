part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {}

class LoadEvent extends CameraEvent {
  final isConnect, fileName, filePath, id;

  LoadEvent({this.isConnect, this.filePath, this.fileName, this.id});
}
