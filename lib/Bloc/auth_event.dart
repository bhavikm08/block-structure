part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}
class ToggleEyeVisibilityEvent extends AuthEvent {}
class ToggleSwitchEvent extends AuthEvent {
 final bool switchOn;
  ToggleSwitchEvent({required this.switchOn});
}
