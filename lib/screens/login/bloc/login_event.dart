part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SignInEvent extends LoginEvent {
  final String username, password, lang, baseUrl;
  final CameraDescription camera;

  SignInEvent({required this.username, required this.password, required this.camera, required this.lang, required this.baseUrl});
}

class UpdateLang extends LoginEvent{
  String lang;
  UpdateLang({required this.lang});
}

class DropDown extends LoginEvent {}

class SaveUrl extends LoginEvent {}