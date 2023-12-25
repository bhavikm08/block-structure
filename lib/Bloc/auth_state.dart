part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthToggleSwitchState extends AuthState {
  final bool switchOn;
  AuthToggleSwitchState({required this.switchOn});
}

class LoginSuccessState extends AuthState {
  final String response;
  LoginSuccessState(this.response);
}

class LoginErrorState extends AuthState {
  final String response;
  LoginErrorState(this.response);
}
