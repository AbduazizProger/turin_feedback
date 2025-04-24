import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feedback/const/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutesModel extends ChangeNotifier {
  String route = Routes.main;

  void setRoute(
    String newRoute, [
    BuildContext? context,
    Map<String, String>? parameters,
  ]) {
    route = newRoute;
    if (context != null) {
      context.goNamed(newRoute, pathParameters: parameters ?? {});
    }
    notifyListeners();
  }

  void signOut(SharedPreferences prefs) {
    prefs.clear();
    notifyListeners();
  }
}
