import 'package:feedback/view_model/bloc/main_bloc.dart';
import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:flutter/material.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/views/widgets/dialog_widget.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  bool isComment = false;
  bool isRequired = true;
  final content = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is MainLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MainErrorState) {
          return Center(child: Text(state.error));
        } else if (state is QuestionAddedState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Question added successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          });
        }
        return DialogWidget(
          title: tr('add-question'),
          content: Column(children: [
            TextField(
              controller: content,
              decoration: InputDecoration(
                hintText: tr('content'),
                hintStyle: TextStyles.greyW400S14,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            Row(children: [
              Checkbox(
                value: isComment,
                onChanged: (value) {
                  setState(() {
                    isComment = value!;
                  });
                },
              ),
              Text(
                tr(isComment ? 'comment' : 'markable'),
                style: TextStyles.blackW400S14,
              ),
              const SizedBox(width: 30),
              Checkbox(
                value: isRequired,
                onChanged: (value) {
                  setState(() {
                    isRequired = value!;
                  });
                },
              ),
              Text(tr('is-required'), style: TextStyles.blackW400S14),
            ]),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(tr('cancel'), style: TextStyles.mainW500S16),
            ),
            TextButton(
              onPressed: () {
                if (content.text.isNotEmpty) {
                  context.read<MainBloc>().add(
                        AddQuestionEvent(
                          data: {
                            'body': content.text,
                            'requirement': isRequired,
                            'type': isComment ? 'Multiple Choice' : 'Comment',
                          },
                          mainRepo: context.read<MainRepo>(),
                        ),
                      );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr('please-fill')),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(tr('add'), style: TextStyles.mainW500S16),
            ),
          ],
        );
      },
    );
  }
}
