import 'package:consultant/models/student_model.dart';
import 'package:consultant/repositories/repository_with_subcollection.dart';

abstract class ClassStudentService {
  Future<Student> addStudent(String id, Student student);
}

class ClassStudentServiceIml extends ClassStudentService{
  final RepositoryWithSubCollection<Student> _repository;
  ClassStudentServiceIml(this._repository);

  @override
  Future<Student> addStudent(String id, Student student) async {
    return await _repository.create(id, student);
  }
}
