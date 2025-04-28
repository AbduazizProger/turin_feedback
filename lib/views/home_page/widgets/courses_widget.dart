import 'dart:ui';
import 'package:feedback/const/routes.dart';
import 'package:feedback/models/data/teacher_model.dart';
import 'package:feedback/models/routes_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback/const/colors.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:feedback/models/data/course_model.dart';
import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:easy_localization/easy_localization.dart';

class CoursesWidget extends StatefulWidget {
  const CoursesWidget({super.key});

  @override
  State<CoursesWidget> createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  int? level;
  int? semester;
  String? teacherID;
  static const majors = [
    null,
    'Software Engineering',
    'Business Management',
    'Information Technology',
    'Art and Design',
    'Mechanical Engineering',
  ];
  static const semesters = [null, 1, 2];
  final major = TextEditingController();
  final List<TeacherModel> teachers = [];
  final teacher = TextEditingController();
  static const levels = [null, 1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
    context.read<MainRepo>().allTeachers().then((value) {
      teachers.add(TeacherModel(
        tid: null,
        lastName: '',
        name: tr('all'),
      ));
      teachers.addAll(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blurColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(children: [
              SizedBox(
                height: 60,
                child: Row(children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width % 400) / 2 - 20,
                  ),
                  Text(tr('courses'), style: TextStyles.blackW700S24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      value: level,
                      hint: Text(tr('level')),
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(12),
                      items: List.generate(levels.length, (index) {
                        return DropdownMenuItem(
                          value: levels[index],
                          child: Text('${levels[index] ?? tr('all')}'),
                        );
                      }),
                      onChanged: (value) => setState(() {
                        level = value;
                      }),
                    ),
                  ),
                  DropdownButton(
                    value: semester,
                    hint: Text(tr('semester')),
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(12),
                    items: List.generate(semesters.length, (index) {
                      return DropdownMenuItem(
                        value: semesters[index],
                        child: Text('${semesters[index] ?? tr('all')}'),
                      );
                    }),
                    onChanged: (value) => setState(() {
                      semester = value;
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownMenu(
                      controller: major,
                      hintText: tr('major'),
                      onSelected: (value) => setState(() {
                        major.text = value!;
                      }),
                      dropdownMenuEntries:
                          List.generate(majors.length, (index) {
                        return DropdownMenuEntry(
                          value: majors[index],
                          label: majors[index] ?? tr('all'),
                        );
                      }),
                    ),
                  ),
                  DropdownMenu(
                    controller: teacher,
                    hintText: tr('teacher'),
                    onSelected: (value) => setState(() {
                      teacherID = value!.tid;
                    }),
                    dropdownMenuEntries:
                        List.generate(teachers.length, (index) {
                      return DropdownMenuEntry(
                        value: teachers[index],
                        label:
                            '${teachers[index].name ?? ''} ${teachers[index].lastName ?? ''}',
                      );
                    }),
                  ),
                ]),
              ),
              FutureBuilder<List<CourseModel>>(
                future: context.read<MainRepo>().allCourses({
                  'level': level,
                  'semester': semester,
                  'teacherId': teacherID,
                  'major': majors.contains(major.text) ? major.text : null,
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: TextStyles.blackW400S14,
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(snapshot.data!.length, (index) {
                      return InkWell(
                        onTap: () {
                          context.read<RoutesModel>().setRoute(
                            Routes.course,
                            context,
                            {'courseId': '${snapshot.data![index].subjectId}'},
                          );
                        },
                        child: Container(
                          width: 350,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.main,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                offset: Offset(0, -3),
                                color: Colors.black12,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                snapshot.data![index].subjectName,
                                maxLines: 1,
                                style: TextStyles.whiteW600S32,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr('rating'),
                                          style: TextStyles.blackW600S14,
                                        ),
                                        Text(
                                          snapshot.data![index].averageRating,
                                          style: TextStyles.blackW400S14,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            tr('teacher'),
                                            style: TextStyles.blackW600S14,
                                          ),
                                          Text(
                                            snapshot.data![index].teacherName,
                                            style: TextStyles.blackW400S14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr('major'),
                                          style: TextStyles.blackW600S14,
                                        ),
                                        Text(
                                          snapshot.data![index].major,
                                          style: TextStyles.blackW400S14,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            tr('level'),
                                            style: TextStyles.blackW600S14,
                                          ),
                                          Text(
                                            "${snapshot.data![index].level}",
                                            style: TextStyles.blackW400S14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr('semester'),
                                          style: TextStyles.blackW600S14,
                                        ),
                                        Text(
                                          "${snapshot.data![index].semester}",
                                          style: TextStyles.blackW400S14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
