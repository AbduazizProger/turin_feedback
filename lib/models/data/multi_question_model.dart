class MultiQuestionModel {
  final String questionBody;
  final Map<String, int> answer;

  MultiQuestionModel({
    required this.questionBody,
    required this.answer,
  });

  factory MultiQuestionModel.fromJson(Map<String, dynamic> json) {
    return MultiQuestionModel(
      questionBody: json['question_body'] as String,
      answer: Map<String, int>.from(json['answer'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_body': questionBody,
      'answer': answer,
    };
  }
}
