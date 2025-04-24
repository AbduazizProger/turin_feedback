class CourseModel {
  final int subjectId;
  final String subjectName;
  final String averageRating;
  final String teacherName;
  final String major;
  final int level;
  final int semester;

  CourseModel({
    required this.subjectId,
    required this.subjectName,
    required this.averageRating,
    required this.teacherName,
    required this.major,
    required this.level,
    required this.semester,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      averageRating: json['average_Rating'],
      teacherName: json['teacher_Name'],
      major: json['major'],
      level: json['level'],
      semester: json['semester'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'subject_name': subjectName,
      'average_Rating': averageRating,
      'teacher_Name': teacherName,
      'major': major,
      'level': level,
      'semester': semester,
    };
  }
}
