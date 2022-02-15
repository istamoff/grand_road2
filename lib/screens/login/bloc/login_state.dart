part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel model;

  LoginSuccess({required this.model});
}

class LoginFail extends LoginState {}

class LoginLoaded extends LoginState {
  final List<String> list;

  LoginLoaded({required this.list});
}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}

class DropDownLoading extends LoginState{}