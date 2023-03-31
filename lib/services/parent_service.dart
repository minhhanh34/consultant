import '../models/parent_model.dart';
import '../repositories/parent_repository.dart';

class ParentService {
  final ParentRepository _repository;

  ParentService(this._repository);

  Future<List<Parent>> getParents() async {
    return await _repository.list();
  }

  Future<Parent> getParentByUid(String uid) async {
    final snap =
        await _repository.collection.where('uid', isEqualTo: uid).get();
    return Parent.fromJson(snap.docs.first.data() as Map<String, dynamic>)
        .copyWith(id: snap.docs.first.id);
  }
}
