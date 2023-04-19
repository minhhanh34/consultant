

import 'package:consultant/repositories/student_repository.dart';

import '../models/student_model.dart';

class StudentService {
  final StudentRepository _repository;

  StudentService(this._repository);

  Future<List<Student>> getStudents() async {
    return _repository.list();
  }

  Future<Student> getStudentByUid(String uid) async {
    final snap =
        await _repository.collection.where('uid', isEqualTo: uid).get();
    return Student.fromJson(snap.docs.first.data() as Map<String, dynamic>)
        .copyWith(id: snap.docs.first.id);
  }

  Future<Student> getStudentById(String id) async {
    return await _repository.getOne(id);
  }

  Future<bool> updateStudent(Student student) async {
    return await _repository.update(student.id!, student);
  }

  Future<List<Student>> query(String query, {Object? isEqualTo}) async {
    final snaps =
        await _repository.collection.where(query, isEqualTo: isEqualTo).get();
    return snaps.docs.map((doc) {
      return Student.fromJson(doc.data() as Map<String, dynamic>)
          .copyWith(id: doc.id);
    }).toList();
  }

  Future<bool> delete(String id) async {
    return await _repository.delete(id);
  }
}
