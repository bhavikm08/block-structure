import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../Repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthInitial());
      try {
        final response = await authRepository.callLogin(
          email: event.email,
          password: event.password,
        );
        if (response.statusCode == 200) {
          emit(LoginSuccessState("Success"));
        } else if (response.statusCode == 404) {
          emit(LoginErrorState("Error"));
        }
      } catch (e) {
        emit(LoginErrorState("Error"));
      }
    });

    on<ToggleSwitchEvent>((event, emit) {
      updateSwitch(event.switchOn);
      emit(AuthInitial());
      print("Event :- ${event.switchOn}");
    });
    on<ToggleEyeVisibilityEvent>((event, emit) {
      updateVisibility();
      emit(AuthInitial());
    });
  }

  bool isSecure = true;
  bool switchOn = false;

  void updateVisibility() {
    isSecure = !isSecure;
  }

  void updateSwitch(bool value) {
    switchOn = value;
    print("SWITCH $switchOn");
  }
}
