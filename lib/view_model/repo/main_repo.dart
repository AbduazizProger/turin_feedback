// ignore_for_file: argument_type_not_assignable_to_error_handler, use_build_context_synchronously, body_might_complete_normally_catch_error

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:feedback/const/routes.dart";
import "package:feedback/models/routes_model.dart";
import "package:feedback/models/data/course_model.dart";
import "package:feedback/models/data/comment_model.dart";
import "package:feedback/models/data/subject_model.dart";
import "package:feedback/models/data/teacher_model.dart";
import "package:feedback/view_model/repo/endpoints.dart";
import "package:feedback/models/data/question_model.dart";
import "package:feedback/models/data/top_worst_model.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:feedback/models/data/course_detail_model.dart";
import "package:feedback/models/data/multi_question_model.dart";

class MainRepo {
  late final Dio dio;
  final BuildContext context;
  final SharedPreferences prefs;

  MainRepo({required this.prefs, required this.context}) {
    dio = Dio();
  }

  Future<List<QuestionModel>> allQuestions() async {
    final response = await dio
        .request(
      Endpoints.questions,
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return (response.data as List)
        .map((e) => QuestionModel.fromJson(e))
        .toList();
  }

  Future<bool> addQuestion(Map<String, dynamic> data) async {
    final response = await dio
        .request(
      Endpoints.question,
      options: Options(method: 'POST', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
      data: data,
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return response.statusCode == 200;
  }

  Future<bool> removeQuestion(int id) async {
    final response = await dio
        .request(
      "${Endpoints.question}$id",
      options: Options(method: 'DELETE', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return response.statusCode == 200;
  }

  Future<List<SubjectModel>> allSubjects() async {
    final response = await dio
        .request(
      Endpoints.subjects,
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return (response.data as List)
        .map((e) => SubjectModel.fromJson(e))
        .toList();
  }

  Future<List<CourseModel>> allCourses([Map<String, dynamic>? filter]) async {
    final response = await dio
        .request(
      Endpoints.filter,
      options: Options(method: 'POST', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
      data: (filter ?? {})..removeWhere((key, value) => value == null),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return (response.data as List).map((e) => CourseModel.fromJson(e)).toList();
  }

  Future<CourseDetailModel> getCourse(String id) async {
    final response = await dio
        .request(
      "${Endpoints.subject}/$id",
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return CourseDetailModel.fromJson(response.data);
  }

  Future<List<CommentModel>> getComments(String id) async {
    final response = await dio
        .request(
      "${Endpoints.comments}$id",
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return (response.data as List)
        .map((e) => CommentModel.fromJson(e))
        .toList();
  }

  Future<List<dynamic>> getMultiQuestions(String id) async {
    final response = await dio
        .request(
      "${Endpoints.feedbackQuestion}$id",
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return (response.data as List)
        .map((e) => MultiQuestionModel.fromJson(e))
        .toList();
  }

  Future<List<TeacherModel>> allTeachers() async {
    final response = await dio
        .request(
      Endpoints.teachers,
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return (response.data as List)
        .map((e) => TeacherModel.fromJson(e))
        .toList();
  }

  Future<bool> addCourse(Map<String, dynamic> data) async {
    final response = await dio
        .request(
      Endpoints.subject,
      options: Options(method: 'POST', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
      data: data,
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return response.statusCode == 200;
  }

  Future<List<TopWorstModel>> topAndWorst(bool isTop, bool isTeacher) async {
    final response = await dio
        .request(
      '${isTop ? Endpoints.top : Endpoints.worst}${isTeacher ? "teachers" : "subjects"}',
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    )
        .catchError((e) {
      if (e.response?.statusCode == 401) {
        prefs.remove('token');
        context.read<RoutesModel>().setRoute(Routes.login, context);
      } else {
        throw e;
      }
    });
    return (response.data as List)
        .map((e) => TopWorstModel.fromJson(e))
        .toList();
  }
}
