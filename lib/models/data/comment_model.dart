class CommentModel {
  final String answer;
  final String questionBody;

  CommentModel({
    required this.answer,
    required this.questionBody,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      answer: json['answer'],
      questionBody: json['question_body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'question_body': questionBody,
    };
  }
}
