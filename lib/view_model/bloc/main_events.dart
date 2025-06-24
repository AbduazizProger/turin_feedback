part of 'main_bloc.dart';

abstract class MainEvent {
  const MainEvent({required this.mainRepo});

  get id => null;
  get data => null;
  final MainRepo mainRepo;
}

class MainInitialEvent extends MainEvent {
  const MainInitialEvent({required super.mainRepo});
}

class AddCourseEvent extends MainEvent {
  const AddCourseEvent({
    required this.data,
    required super.mainRepo,
  });

  @override
  final Map<String, dynamic> data;
}

class AddQuestionEvent extends MainEvent {
  const AddQuestionEvent({
    required this.data,
    required super.mainRepo,
  });

  @override
  final Map<String, dynamic> data;
}

class RemoveQuestionEvent extends MainEvent {
  const RemoveQuestionEvent({
    required this.id,
    required super.mainRepo,
  });

  @override
  final int id;
}
