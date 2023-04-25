import 'package:consultant/repositories/repository_interface.dart';

import '../models/parent_model.dart';

abstract class ParentService {
  Future<List<Parent>> getParents();
  Future<Parent> getParentByUid(String uid);
  Future<Parent> get(String id);
}

class ParentServiceIml extends ParentService{
  final Repository<Parent> _repository;

  ParentServiceIml(this._repository);

  @override
  Future<List<Parent>> getParents() async {
    return await _repository.list();
  }

  @override
  Future<Parent> getParentByUid(String uid) async {
    final snap =
        await _repository.collection.where('uid', isEqualTo: uid).get();
    return Parent.fromJson(snap.docs.first.data() as Map<String, dynamic>)
        .copyWith(id: snap.docs.first.id);
  }

  @override
  Future<Parent> get(String id) async {
    return await _repository.getOne(id) as Parent;
  }
}
