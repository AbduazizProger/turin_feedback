import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedback/view_model/repo/main_repo.dart';

part 'main_events.dart';
part 'main_states.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<MainEvent>((event, emit) async {
      emit(MainLoading());
      try {
        if (event is MainInitialEvent) {
          emit(MainInitial());
        } else if (event is RemoveQuestionEvent) {
          final result = await event.mainRepo.removeQuestion(event.id);
          if (result) {
            emit(QuestionRemovedState());
          } else {
            throw Exception("Failed to remove question");
          }
        } else if (event is AddQuestionEvent) {
          final result = await event.mainRepo.addQuestion(event.data);
          if (result) {
            emit(QuestionAddedState());
          } else {
            throw Exception("Failed to add question");
          }
        } else if (event is AddCourseEvent) {
          final result = await event.mainRepo.addCourse(event.data);
          if (result) {
            emit(CourseAddedState());
          } else {
            throw Exception("Failed to add course");
          }
        }
      } catch (e) {
        emit(MainErrorState(error: e.toString()));
      }
    });
  }
}
