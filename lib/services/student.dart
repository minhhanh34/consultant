import 'package:consultant/repositories/student_repository.dart';

import '../models/student.dart';

class StudentService {
  final StudentRepository repository;

  StudentService(this.repository);

  Future<List<Student>> getStudents() async {
    return repository.list();
  }
}
