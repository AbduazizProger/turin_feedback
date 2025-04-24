class TopWorstModel {
  final int? id;
  final String? name;
  final double? rating;

  TopWorstModel({required this.id, required this.name, required this.rating});

  factory TopWorstModel.fromJson(Map<String, dynamic> json) {
    return TopWorstModel(
      rating: json['rating'],
      id: json['idsubject_id'],
      name: json['subject_name'] ?? json['teacher_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'idsubject_id': id,
    }..removeWhere((key, value) => value == null && key == 'idsubject_id');
  }
}
