import 'package:labs/entity/subject.dart';
import 'package:labs/repository/subject_repository.dart';

class SubjectService {
  final SubjectRepository _subjectRepository;

  SubjectService(this._subjectRepository);

  Future<List<Subject>> getSubjects(String userId) async {
    return await _subjectRepository.getSubjects(userId);
  }

  Future<void> addSubject(Subject subject) async {
    await _subjectRepository.addSubject(subject);
  }

  Future<void> updateSubject(Subject subject) async {
    await _subjectRepository.updateSubject(subject);
  }
}
