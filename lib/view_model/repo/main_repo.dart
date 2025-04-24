import "package:dio/dio.dart";
import "package:feedback/models/data/comment_model.dart";
import "package:feedback/models/data/course_detail_model.dart";
import "package:feedback/models/data/course_model.dart";
import "package:feedback/models/data/subject_model.dart";
import "package:feedback/models/data/teacher_model.dart";
import "package:feedback/models/data/top_worst_model.dart";
import "package:feedback/view_model/repo/endpoints.dart";
import "package:feedback/models/data/question_model.dart";
import "package:shared_preferences/shared_preferences.dart";

class MainRepo {
  late final Dio dio;
  final SharedPreferences prefs;

  MainRepo({required this.prefs}) {
    dio = Dio();
  }

  Future<List<QuestionModel>> allQuestions() async {
    final response = await dio.request(
      Endpoints.questions,
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    );
    return (response.data as List)
        .map((e) => QuestionModel.fromJson(e))
        .toList();
  }

  Future<bool> addQuestion(Map<String, dynamic> data) async {
    final response = await dio.request(
      Endpoints.question,
      options: Options(method: 'POST', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
      data: data,
    );
    return response.statusCode == 200;
  }

  Future<bool> removeQuestion(int id) async {
    final response = await dio.request(
      "${Endpoints.question}$id",
      options: Options(method: 'DELETE', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    );
    return response.statusCode == 200;
  }

  Future<List<SubjectModel>> allSubjects() async {
    final response = await dio.request(
      Endpoints.subjects,
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    );
    return (response.data as List)
        .map((e) => SubjectModel.fromJson(e))
        .toList();
  }

  Future<List<CourseModel>> allCourses([Map<String, dynamic>? filter]) async {
    final response = await dio.request(
      Endpoints.filter,
      options: Options(method: 'POST', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
      data: filter,
    );
    return (response.data as List).map((e) => CourseModel.fromJson(e)).toList();
  }

  Future<CourseDetailModel> getCourse(String id) async {
    final response = await dio.request(
      "${Endpoints.subject}/$id",
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    );
    return CourseDetailModel.fromJson(response.data);
  }

  Future<List<CommentModel>> getComments(String id) async {
    final response = await dio.request(
      "${Endpoints.comments}$id",
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    );
    return (response.data as List)
        .map((e) => CommentModel.fromJson(e))
        .toList();
  }

  Future<List<TeacherModel>> allTeachers() async {
    final response = await dio.request(
      Endpoints.teachers,
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    );
    return (response.data as List)
        .map((e) => TeacherModel.fromJson(e))
        .toList();
  }

  Future<bool> addCourse(Map<String, dynamic> data) async {
    final response = await dio.request(
      Endpoints.subject,
      options: Options(method: 'POST', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
      data: data,
    );
    return response.statusCode == 200;
  }

  Future<List<TopWorstModel>> topAndWorst(bool isTop, bool isTeacher) async {
    final response = await dio.request(
      '${isTop ? Endpoints.top : Endpoints.worst}${isTeacher ? "teachers" : "subjects"}',
      options: Options(method: 'GET', headers: {
        "Accept": "application/json",
        "authorization": "Bearer ${prefs.getString("token")}",
      }),
    );
    return (response.data as List)
        .map((e) => TopWorstModel.fromJson(e))
        .toList();
  }
}
