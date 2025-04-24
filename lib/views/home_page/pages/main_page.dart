import 'package:feedback/views/home_page/widgets/courses_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback/const/colors.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/models/data/top_worst_model.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: 360,
            height: 300,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
              Text(
                tr(index == 0
                    ? 'top-5-teachers'
                    : index == 1
                        ? 'top-5-courses'
                        : index == 2
                            ? 'worst-5-teachers'
                            : 'worst-5-courses'),
                style: TextStyles.mainW600S32,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                  child: FutureBuilder<List<TopWorstModel>>(
                    future: context.read<MainRepo>().topAndWorst(
                          index < 2,
                          index == 0 || index == 2,
                        ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: TextStyles.blackW400S14,
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Row(
                        children:
                            List.generate(snapshot.data!.length, (rankIndex) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                snapshot
                                        .data![snapshot.data!.length -
                                            1 -
                                            rankIndex]
                                        .name ??
                                    '',
                                style: TextStyles.blackW400S7,
                              ),
                              Container(
                                width: 58,
                                height: 198 *
                                    (snapshot
                                            .data![snapshot.data!.length -
                                                1 -
                                                rankIndex]
                                            .rating ??
                                        0) /
                                    10,
                                margin: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  gradient: AppColors.mainGradient,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(5),
                                  ),
                                ),
                                child: Column(children: [
                                  Text(
                                    '${snapshot.data![snapshot.data!.length - 1 - rankIndex].rating ?? 0}',
                                    style: TextStyles.whiteW400S12,
                                  ),
                                  const Text(
                                    'Excellent',
                                    style: TextStyles.whiteW400S7,
                                  ),
                                ]),
                              ),
                            ],
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ]),
          );
        }),
      ),
      const CoursesWidget(),
    ]);
  }
}
