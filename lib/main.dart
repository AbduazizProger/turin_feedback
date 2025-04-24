import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback/const/colors.dart';
import 'package:feedback/const/routes.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedback/models/routes_model.dart';
import 'package:feedback/view_model/bloc/auth_bloc.dart';
import 'package:feedback/view_model/bloc/main_bloc.dart';
import 'package:feedback/view_model/repo/auth_repo.dart';
import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  if (!const bool.fromEnvironment('dart.vm.product')) {
    setPathUrlStrategy();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  runApp(EasyLocalization(
    saveLocale: true,
    path: 'assets/languages',
    supportedLocales: const [
      Locale('en', 'UZ'),
      // Locale('uz', 'UZ'),
      // Locale('uz', 'RU'),
      // Locale('ru', 'RU'),
    ],
    startLocale: const Locale('en', 'UZ'),
    child: MultiBlocProvider(
      providers: [
        Provider(create: (context) => prefs),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => MainBloc()),
        Provider(create: (context) => AuthRepo(prefs: prefs)),
        Provider(create: (context) => MainRepo(prefs: prefs)),
        ChangeNotifierProvider(create: (context) => RoutesModel()),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Feedback',
      locale: context.locale,
      routerConfig: Routes.router,
      debugShowCheckedModeBanner: false,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.main),
      ),
    );
  }
}
