import 'package:consultant/models/student_model.dart';
import 'package:consultant/repositories/class_student_subcollection_repository.dart';

class ClassStudentService {
  final ClassStudentRepository _repository;
  ClassStudentService(this._repository);

  Future<Student> addStudent(String id, Student student) async {
    return await _repository.create(id, student);
  }
}