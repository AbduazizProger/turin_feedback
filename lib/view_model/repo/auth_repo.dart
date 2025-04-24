import 'package:dio/dio.dart';
import 'package:feedback/view_model/repo/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  late final Dio dio;
  final SharedPreferences prefs;

  AuthRepo({required this.prefs}) {
    dio = Dio();
  }

  Future<bool> signIn(String username, String password) async {
    final response = await dio.request(
      Endpoints.signIn,
      options: Options(method: 'POST', headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      }),
      data: {"username": username, "password": password},
    );
    if (response.statusCode != 200) {
      return false;
    }
    prefs.setString("token", response.data["access_token"]);
    return true;
  }
}
