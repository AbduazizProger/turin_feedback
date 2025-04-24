class QuestionModel {
  final int? id;
  final int? order;
  final String? header;
  final String? body;
  final bool? requirement;
  final String? type;
  final bool? isActive;

  QuestionModel({
    required this.id,
    required this.order,
    required this.header,
    required this.body,
    required this.requirement,
    required this.type,
    required this.isActive,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      order: json['order'],
      header: json['header'],
      body: json['body'],
      requirement: json['requirement'],
      type: json['type'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'header': header,
      'body': body,
      'requirement': requirement,
      'type': type,
      'is_active': isActive,
    };
  }
}
