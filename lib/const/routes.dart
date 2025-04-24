import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:feedback/models/routes_model.dart';
import 'package:feedback/views/home_page/home_page.dart';
import 'package:feedback/views/login_page/login_page.dart';
import 'package:feedback/views/home_page/pages/main_page.dart';
import 'package:feedback/views/home_page/pages/course_page.dart';
import 'package:feedback/views/home_page/pages/question_page.dart';

final GoRouter _router = GoRouter(
  initialLocation: Routes.main,
  routes: [
    GoRoute(
      name: Routes.login,
      path: Routes.login,
      builder: (context, state) {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => context.read<RoutesModel>().setRoute(Routes.login),
        );
        return const LoginPage();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return HomePage(child: child);
      },
      routes: [
        GoRoute(
          name: Routes.main,
          path: Routes.main,
          builder: (context, state) {
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => context.read<RoutesModel>().setRoute(Routes.main),
            );
            return const MainPage();
          },
        ),
        GoRoute(
          name: Routes.course,
          path: Routes.course,
          builder: (context, state) {
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => context.read<RoutesModel>().setRoute(Routes.course),
            );
            return CoursePage(id: state.pathParameters['courseId'] ?? '');
          },
        ),
        GoRoute(
          name: Routes.questions,
          path: Routes.questions,
          builder: (context, state) {
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => context.read<RoutesModel>().setRoute(Routes.questions),
            );
            return const QuestionPage();
          },
        ),
      ],
    )
  ],
);

class Routes {
  static const String main = '/';
  static const String login = '/login';
  static const String questions = '/questions';
  static const String course = '/course/:courseId';

  static GoRouter get router => _router;
}
