import 'package:consultant/repositories/student_repository.dart';

import '../models/student.dart';

class StudentService {
  final StudentRepository _repository;

  StudentService(this._repository);

  Future<List<Student>> getStudents() async {
    return _repository.list();
  }
}
