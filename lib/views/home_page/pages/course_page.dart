// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback/const/colors.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/models/data/course_detail_model.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final showComments = ValueNotifier(true);

    return FutureBuilder<CourseDetailModel>(
      future: context.read<MainRepo>().getCourse(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}', style: TextStyles.blackW400S24),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(children: [
          Container(
            height: 70,
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(children: [
              Expanded(
                child: Text(
                  snapshot.data!.teacherName,
                  textAlign: TextAlign.center,
                  style: TextStyles.blackW400S24,
                ),
              ),
              Container(width: 1, height: 70, color: Colors.grey),
              Expanded(
                child: Text(
                  snapshot.data!.subjectName,
                  textAlign: TextAlign.center,
                  style: TextStyles.blackW400S24,
                ),
              ),
              Container(width: 1, height: 70, color: Colors.grey),
              Expanded(
                child: Text(
                  snapshot.data!.major,
                  textAlign: TextAlign.center,
                  style: TextStyles.blackW400S24,
                ),
              ),
              Container(width: 1, height: 70, color: Colors.grey),
              Expanded(
                child: Text(
                  '${tr('level')} ${snapshot.data!.level}',
                  textAlign: TextAlign.center,
                  style: TextStyles.blackW400S24,
                ),
              ),
              Container(width: 1, height: 70, color: Colors.grey),
              Expanded(
                child: Text(
                  '${tr('semester')} ${snapshot.data!.semester}',
                  textAlign: TextAlign.center,
                  style: TextStyles.blackW400S24,
                ),
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
                FittedBox(
                  child: Container(
                    height: 300,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            snapshot.data!.feedback.values.length,
                            (index) {
                              return Column(children: [
                                Text(
                                  "${snapshot.data!.feedback.values.toList().reversed.elementAt(index)}",
                                  textAlign: TextAlign.center,
                                  style: TextStyles.blackW400S24,
                                ),
                                Container(
                                  width: 80,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  height: (snapshot.data!.feedback.values
                                              .toList()
                                              .reversed
                                              .elementAt(index) /
                                          ((snapshot.data!.feedback.values
                                                          .toList()
                                                        ..sort())
                                                      .last !=
                                                  0
                                              ? (snapshot.data!.feedback.values
                                                      .toList()
                                                    ..sort())
                                                  .last
                                              : 1)) *
                                      174,
                                  decoration: const BoxDecoration(
                                    color: AppColors.main2,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ]);
                            },
                          ),
                        ),
                        const Divider(thickness: 2, color: Colors.black),
                        Row(
                          children: List.generate(
                            snapshot.data!.feedback.keys.length,
                            (index) {
                              return SizedBox(
                                width: 86,
                                child: Text(
                                  tr(snapshot.data!.feedback.keys
                                      .toList()
                                      .reversed
                                      .elementAt(index)),
                                  textAlign: TextAlign.center,
                                  style: TextStyles.blackW600S16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 350,
                  height: 350,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(360),
                  ),
                ),
                ShowQuestionsWidget(
                  showComments: showComments,
                  subjectId: snapshot.data!.subjectId,
                ),
              ]),
            ),
          )
        ]);
      },
    );
  }
}

class ShowQuestionsWidget extends StatelessWidget {
  const ShowQuestionsWidget({
    super.key,
    required this.subjectId,
    required this.showComments,
  });

  final int subjectId;
  final ValueNotifier<bool> showComments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blurColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: FutureBuilder<List<List>>(
              future: (() async => [
                    await context.read<MainRepo>().getComments('$subjectId'),
                    await context
                        .read<MainRepo>()
                        .getMultiQuestions('$subjectId'),
                  ])(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data![0];
                final multiQuestions = snapshot.data![1];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toggle Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: showComments,
                        builder: (context, isComments, _) {
                          return ToggleButtons(
                            isSelected: [isComments, !isComments],
                            onPressed: (index) {
                              showComments.value = index == 0;
                            },
                            borderRadius: BorderRadius.circular(8),
                            selectedColor: Colors.white,
                            fillColor: AppColors.main2,
                            color: Colors.black,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(tr('comments')),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(tr('multiple-choices')),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Content based on toggle
                    ValueListenableBuilder<bool>(
                      valueListenable: showComments,
                      builder: (context, isComments, _) {
                        return isComments
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      tr('comments'),
                                      style: TextStyles.blackW700S24,
                                    ),
                                  ),
                                  ...List.generate(comments.length, (index) {
                                    final item = comments[index];
                                    return buildQuestionAnswerItem(index, item);
                                  }),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      tr('multiple-choices'),
                                      style: TextStyles.blackW700S24,
                                    ),
                                  ),
                                  ...List.generate(multiQuestions.length,
                                      (index) {
                                    final item = multiQuestions[index];
                                    return buildQuestionAnswerItem(index, item);
                                  }),
                                ],
                              );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildQuestionAnswerItem(int index, dynamic item) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${index + 1}", style: TextStyles.blackW700S20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.questionBody,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.blackW700S24,
              ),
            ),
            const SizedBox(width: 20),
            item.answer is String
                ? Text(item.answer, style: TextStyles.blackW400S24)
                : SizedBox(
                    width: 200,
                    child: Column(
                      children: List.generate(
                        (item.answer as Map).length,
                        (i) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr('${(item.answer as Map).keys.elementAt(i)}'),
                              style: TextStyles.blackW400S14,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              (item.answer as Map)
                                  .values
                                  .elementAt(i)
                                  .toString(),
                              style: TextStyles.blackW400S14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey),
      ],
    ),
  );
}
