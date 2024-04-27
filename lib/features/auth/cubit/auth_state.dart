import 'package:meta/meta.dart';
@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class UserRegisterLoading extends AuthState {}

class UserRegisterSuccess extends AuthState {}

class UserRegisterError extends AuthState {
  final String message;

  UserRegisterError({
    required this.message,
  });
}

class UserLoginLoading extends AuthState {}

class UserLoginSuccess extends AuthState {
  final String uId;

  UserLoginSuccess({ required this.uId});
}

class UserLoginError extends AuthState {
  final String message;

  UserLoginError({
    required this.message,
  });
}


class UserCreateLoading extends AuthState {}

class UserCreateSuccess extends AuthState {}

class UserCreateError extends AuthState {
  final String message;

  UserCreateError({
    required this.message,
  });
}