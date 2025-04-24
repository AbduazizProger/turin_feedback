part of 'auth_bloc.dart';

abstract class AuthState {
  const AuthState();

  get message => null;
}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  @override
  final String message;

  const AuthErrorState({required this.message});
}

class SignInState extends AuthState {}
