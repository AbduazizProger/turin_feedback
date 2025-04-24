class CourseDetailModel {
  final int subjectId;
  final String teacherName;
  final String subjectName;
  final String major;
  final int level;
  final String startYear;
  final int semester;
  final Map<String, dynamic> feedback;
  final String avarage;

  CourseDetailModel({
    required this.subjectId,
    required this.teacherName,
    required this.subjectName,
    required this.major,
    required this.level,
    required this.startYear,
    required this.semester,
    required this.feedback,
    required this.avarage,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      subjectId: json['subject_id'],
      teacherName: json['teacher_name'],
      subjectName: json['subject_name'],
      major: json['major'],
      level: json['level'],
      startYear: json['start_year'],
      semester: json['semester'],
      feedback: json['feedback'],
      avarage: json['avarage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'teacher_name': teacherName,
      'subject_name': subjectName,
      'major': major,
      'level': level,
      'start_year': startYear,
      'semester': semester,
      'feedback': feedback,
      'avarage': avarage,
    };
  }
}
