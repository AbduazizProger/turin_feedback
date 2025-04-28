import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback/const/colors.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:feedback/models/data/comment_model.dart';
import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/models/data/course_detail_model.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
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
                Padding(
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
                        child: FutureBuilder<List<CommentModel>>(
                          future: context.read<MainRepo>().getComments(
                                '${snapshot.data!.subjectId}',
                              ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(children: [
                                    Text(
                                      tr('comments'),
                                      style: TextStyles.blackW700S24,
                                    ),
                                  ]),
                                ),
                                Column(
                                  children: List.generate(
                                    snapshot.data?.length ?? 0,
                                    (index) {
                                      return Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(15),
                                        // decoration: BoxDecoration(
                                        //   borderRadius: BorderRadius.circular(10),
                                        //   border: Border.all(
                                        //     width: 2,
                                        //     color: Colors.grey,
                                        //   ),
                                        // ),
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${index + 1}",
                                                style: TextStyles.blackW700S20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data![index]
                                                      .questionBody,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyles.blackW700S24,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Text(
                                                snapshot.data![index].answer,
                                                style: TextStyles.blackW400S24,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          const Divider(color: Colors.grey),
                                        ]),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          )
        ]);
      },
    );
  }
}
