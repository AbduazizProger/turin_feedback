class SubjectModel {
  final int? subjectId;
  final String? subjectName;

  SubjectModel({
    required this.subjectId,
    required this.subjectName,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'subject_name': subjectName,
    };
  }
}
