import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:feedback/view_model/repo/main_repo.dart';
import 'package:feedback/view_model/bloc/main_bloc.dart';
import 'package:feedback/models/data/question_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/views/home_page/widgets/add_question.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is MainLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MainErrorState) {
          return Center(child: Text(state.error));
        } else if (state is QuestionRemovedState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Question removed successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          });
        }
        return Stack(alignment: Alignment.topRight, children: [
          FutureBuilder<dynamic>(
            future: context.read<MainRepo>().allQuestions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        // height: 50,
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(
                          minWidth: 500,
                          maxWidth: 500,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${(snapshot.data[index] as QuestionModel).order ?? ''}. ",
                                  style: TextStyles.blackW600S16,
                                ),
                                Expanded(
                                  child: Text(
                                    (snapshot.data[index] as QuestionModel)
                                            .body ??
                                        '',
                                    style: TextStyles.blackW400S14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<MainBloc>().add(
                                          RemoveQuestionEvent(
                                            id: (snapshot.data[index]
                                                        as QuestionModel)
                                                    .id ??
                                                -1,
                                            mainRepo: context.read<MainRepo>(),
                                          ),
                                        );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              (snapshot.data[index] as QuestionModel).type ??
                                  '',
                              style: TextStyles.blackW400S14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No data'));
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AddQuestion();
                  },
                );
              },
              child: Text(tr('add-question'), style: TextStyles.whiteW400S14),
            ),
          ),
        ]);
      },
    );
  }
}
