part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent({required this.authRepo});

  final AuthRepo authRepo;

  get username => null;
  get password => null;
}

class SignInEvent extends AuthEvent {
  @override
  final String username;
  @override
  final String password;

  const SignInEvent({
    required this.username,
    required this.password,
    required super.authRepo,
  });
}
