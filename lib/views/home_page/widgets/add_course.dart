import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:feedback/view_model/bloc/main_bloc.dart';
import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/views/widgets/dialog_widget.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  int level = 1;
  String? teacherID;
  int semester = 1;
  final majors = [
    'Software Engineering',
    'Business Management',
    'Information Technology',
    'Art and Design',
    'Mechanical Engineering',
  ];
  final levels = [1, 2, 3, 4];
  final name = TextEditingController();
  final major = TextEditingController();
  final teacher = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is MainLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MainErrorState) {
          return Center(child: Text(state.error));
        } else if (state is CourseAddedState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(tr('course-added')),
                duration: const Duration(seconds: 2),
              ),
            );
          });
        }
        return DialogWidget(
          title: tr('add-course'),
          content: FutureBuilder<dynamic>(
            future: context.read<MainRepo>().allTeachers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data.isEmpty) {
                return Center(child: Text(tr('no-teachers')));
              }
              return Column(children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: tr('subject-name'),
                    hintStyle: TextStyles.greyW400S14,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownMenu(
                    controller: major,
                    hintText: tr('major'),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      constraints: const BoxConstraints(maxHeight: 42),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                    ),
                    trailingIcon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    selectedTrailingIcon: const Icon(
                      Icons.keyboard_arrow_up,
                    ),
                    dropdownMenuEntries: List.generate(majors.length, (index) {
                      return DropdownMenuEntry(
                          value: index, label: majors[index]);
                    }),
                  ),
                ),
                DropdownMenu(
                  controller: teacher,
                  hintText: tr('teacher'),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    constraints: const BoxConstraints(maxHeight: 42),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                  ),
                  trailingIcon: const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                  selectedTrailingIcon: const Icon(
                    Icons.keyboard_arrow_up,
                  ),
                  onSelected: (value) {
                    // setState(() {
                    teacherID = value.tid;
                    teacher.text =
                        "${value.lastName ?? ''} ${value.name ?? ''}";
                    // });
                  },
                  dropdownMenuEntries:
                      List.generate(snapshot.data.length, (index) {
                    return DropdownMenuEntry(
                      value: snapshot.data[index],
                      label:
                          "${snapshot.data[index].lastName} ${snapshot.data[index].name}",
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButton<int>(
                    hint: Text(tr("select-level")),
                    value: level,
                    items: levels.map((level2) {
                      return DropdownMenuItem<int>(
                        value: level2,
                        child: Text("Level $level2"),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      level = value ?? 1;
                    }),
                  ),
                ),
                DropdownButton<int>(
                  hint: Text(tr("select-semester")),
                  value: semester,
                  items: [1, 2].map((semester2) {
                    return DropdownMenuItem<int>(
                      value: semester2,
                      child: Text("Semester $semester2"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      semester = value ?? 1;
                    });
                  },
                ),
              ]);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(tr('cancel')),
            ),
            TextButton(
              onPressed: () {
                context.read<MainBloc>().add(
                      AddCourseEvent(
                        data: {
                          "subject_name": name.text,
                          "major": major.text,
                          "teacher_tid": teacherID,
                          "level": level,
                          "semester": semester,
                          "start_year":
                              DateTime.now().toString().substring(0, 10),
                        },
                        mainRepo: context.read<MainRepo>(),
                      ),
                    );
              },
              child: Text(tr('add')),
            ),
          ],
        );
      },
    );
  }
}
