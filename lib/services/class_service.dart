import 'package:consultant/repositories/class_repository.dart';

import '../models/class_model.dart';

class ClassService {
  final ClassRepository _repository;
  ClassService(this._repository);
  Future<Class> create(Class item) async {
    return await _repository.create(item);
  }

  Future<bool> delete(String id) async {
    return await _repository.delete(id);
  }

  Future<Class> getOne(String id) async {
    return await _repository.getOne(id);
  }

  Future<List<Class>> list() async {
    return await _repository.list();
  }

  Future<bool> update(String id, Class item) async {
    return await _repository.update(id, item);
  }

  Future<List<Class>> fetchClasses(String id) async {
    final querySnaps =
        await _repository.collection.where('consultantId', isEqualTo: id).get();
    return querySnaps.docs.map((doc) {
      return Class.fromJson(
        doc.data() as Map<String, dynamic>,
      ).copyWith(id: doc.id);
    }).toList();
  }
}
