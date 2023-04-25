import 'package:consultant/models/parent_model.dart';

import '../models/class_model.dart';
import '../repositories/repository_interface.dart';


abstract class SettingsService {
  Future<Parent> create(Parent parent);
  Future<Parent> fetchParent(String id);
  Future<bool> updateParentInfo(String id, Parent parent);
  Future<List<Class>> fetchClassesForParent(String parentId);
}

class SettingsServiceIml extends SettingsService {
  final Repository<Parent> _repository;
  final Repository<Class> _classRepository;
  SettingsServiceIml(this._repository, this._classRepository);

  @override
  Future<Parent> create(Parent parent) async {
    return await _repository.create(parent);
  }

  @override
  Future<Parent> fetchParent(String id) async {
    return await _repository.getOne(id) as Parent;
  }

  @override
  Future<bool> updateParentInfo(String id, Parent parent) async {
    return await _repository.update(id, parent);
  }

  @override
  Future<List<Class>> fetchClassesForParent(String parentId) async {
    final snaps = await _classRepository.collection
        .where('parentId', isEqualTo: parentId)
        .get();
    return snaps.docs.map((doc) {
      return Class.fromJson(doc.data() as Map<String, dynamic>)
          .copyWith(id: doc.id);
    }).toList();
  }
}
