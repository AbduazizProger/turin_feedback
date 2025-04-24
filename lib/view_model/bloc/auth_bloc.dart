import 'package:feedback/view_model/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_events.dart';
part 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        if (event is SignInEvent) {
          final result = await event.authRepo.signIn(
            event.username,
            event.password,
          );
          if (result) {
            emit(SignInState());
          } else {
            emit(const AuthErrorState(message: "Invalid credentials"));
          }
          emit(SignInState());
        }
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });
  }
}
