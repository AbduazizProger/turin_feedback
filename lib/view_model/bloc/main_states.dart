part of 'main_bloc.dart';

abstract class MainState {
  get error => null;
}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainErrorState extends MainState {
  @override
  final String error;

  MainErrorState({required this.error});
}

class CourseAddedState extends MainState {}

class QuestionAddedState extends MainState {}

class QuestionRemovedState extends MainState {}
