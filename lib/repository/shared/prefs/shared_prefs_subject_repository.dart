import 'package:labs/entity/subject.dart';
import 'package:labs/repository/subject_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsSubjectRepository extends SubjectRepository {
  static const _subjectsKey = 'subjects';

  final SharedPreferences _prefs;

  SharedPrefsSubjectRepository(this._prefs);

  Future<List<Subject>> getAllSubjects() async {
    final subjectsJson = _prefs.getStringList(_subjectsKey) ?? [];
    return subjectsJson.map(Subject.fromJson).toList();
  }

  @override
  Future<List<Subject>> getSubjects(String userId) async {
    final subjects = await getAllSubjects();
    return subjects.where((s) => s.userId == userId).toList();
  }

  @override
  Future<void> addSubject(Subject subject) async {
    final subjects = await getAllSubjects();
    subjects.add(subject);
    await _prefs.setStringList(_subjectsKey, subjects.map((s) => s.toJson())
        .toList(),);
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    final subjects = await getAllSubjects();
    final index = subjects.indexWhere((s) => s.name == subject.name);
    if (index != -1) {
      subjects[index] = subject;
      await _prefs.setStringList(_subjectsKey, subjects.map((s) => s.toJson())
          .toList(),);
    }
  }

  @override
  Future<void> deleteSubject(Subject subject) async {
    final subjects = await getAllSubjects();
    subjects.removeWhere((s) => s.name == subject.name);
    await _prefs.setStringList(_subjectsKey, subjects.map((s) => s.toJson())
        .toList(),);
  }
}
