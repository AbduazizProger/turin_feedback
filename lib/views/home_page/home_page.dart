import 'package:feedback/const/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:feedback/const/routes.dart';
import 'package:feedback/models/routes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feedback/views/home_page/widgets/new_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final search = TextEditingController();
    if (!context.read<SharedPreferences>().containsKey('token')) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => context.read<RoutesModel>().setRoute(Routes.login, context),
      );
    }
    return Scaffold(
      body: Column(children: [
        NewAppBar(search: search),
        Expanded(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                Images.background1,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  Images.background2,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
            Center(child: Image.asset(Images.logo, height: 450)),
            Positioned.fill(
              child: KeyedSubtree(key: GlobalKey(), child: child),
            ),
          ]),
        ),
      ]),
    );
  }
}
