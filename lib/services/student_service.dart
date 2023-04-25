import 'package:consultant/repositories/repository_interface.dart';

import '../models/student_model.dart';

abstract class StudentService {
  Future<List<Student>> getStudents();
  Future<Student> getStudentByUid(String uid);
  Future<Student> getStudentById(String id);
  Future<bool> updateStudent(Student student);
  Future<List<Student>> query(String query, {Object? isEqualTo});
  Future<bool> delete(String id);
}

class StudentServiceIml extends StudentService {
  final Repository<Student> _repository;

  StudentServiceIml(this._repository);

  @override
  Future<List<Student>> getStudents() async {
    return _repository.list();
  }

  @override
  Future<Student> getStudentByUid(String uid) async {
    final snap =
        await _repository.collection.where('uid', isEqualTo: uid).get();
    return Student.fromJson(snap.docs.first.data() as Map<String, dynamic>)
        .copyWith(id: snap.docs.first.id);
  }

  @override
  Future<Student> getStudentById(String id) async {
    return await _repository.getOne(id) as Student;
  }

  @override
  Future<bool> updateStudent(Student student) async {
    return await _repository.update(student.id!, student);
  }

  @override
  Future<List<Student>> query(String query, {Object? isEqualTo}) async {
    final snaps =
        await _repository.collection.where(query, isEqualTo: isEqualTo).get();
    return snaps.docs.map((doc) {
      return Student.fromJson(doc.data() as Map<String, dynamic>)
          .copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<bool> delete(String id) async {
    return await _repository.delete(id);
  }
}
