class TeacherModel {
  final String? tid;
  final String? name;
  final String? lastName;

  TeacherModel({
    required this.tid,
    required this.name,
    required this.lastName,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      tid: json['tid'],
      name: json['name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tid': tid,
      'name': name,
      'last_name': lastName,
    };
  }
}
