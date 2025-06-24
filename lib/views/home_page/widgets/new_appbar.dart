import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:flutter/material.dart';
import 'package:feedback/const/images.dart';
import 'package:feedback/const/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:feedback/models/routes_model.dart';
import 'package:feedback/view_model/bloc/main_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feedback/views/home_page/widgets/add_course.dart';

class NewAppBar extends StatelessWidget {
  const NewAppBar({super.key, required this.search});

  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Image.asset(Images.logo2, height: 70),
        ),
        TextButton(
          onPressed: () {
            context.read<RoutesModel>().setRoute(Routes.main, context);
          },
          child: Text(tr('main'), style: TextStyles.mainW500S16),
        ),
        TextButton(
          onPressed: () {
            context.read<RoutesModel>().setRoute(Routes.questions, context);
          },
          child: Text(tr('questions'), style: TextStyles.mainW500S16),
        ),
      ]),
      Row(children: [
        SizedBox(
          width: 300,
          child: TextField(
            controller: search,
            decoration: InputDecoration(
              hintText: tr('search'),
              hintStyle: TextStyles.greyW400S14,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
        PopupMenuButton(
          offset: const Offset(0, 40),
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    context.read<MainBloc>().add(MainInitialEvent(
                          mainRepo: context.read<MainRepo>(),
                        ));
                    return const AddCourse();
                  },
                );
              },
              child: Text(tr('create-course')),
            ),
            PopupMenuItem(
              onTap: () {
                context.read<RoutesModel>().setRoute(Routes.questions, context);
              },
              child: Text(tr('questions')),
            ),
            PopupMenuItem(
              onTap: () {
                context.read<SharedPreferences>().remove('token');
                context.read<RoutesModel>().setRoute(Routes.login, context);
              },
              child: Text(tr('logout')),
            ),
          ],
        ),
      ]),
    ]);
  }
}
