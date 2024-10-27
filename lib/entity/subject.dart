import 'dart:convert';

class Subject {
  final String id;
  final String name;
  final int totalLabs;
  int completedLabs;
  String userId;

  Subject(this.id, this.name, this.totalLabs, this.completedLabs, this.userId);

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'name': name,
      'totalLabs': totalLabs,
      'completedLabs': completedLabs,
      'userId': userId,
    };
    return jsonEncode(data);
  }

  static Subject fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json) as Map<String, dynamic>;
    return Subject(
      data['id'] as String,
      data['name'] as String,
      data['totalLabs'] as int,
      data['completedLabs'] as int,
      data['userId'] as String,
    );
  }
}
