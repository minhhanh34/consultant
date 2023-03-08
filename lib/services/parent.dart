import '../models/parent.dart';
import '../repositories/parent_repository.dart';

class ParentService {
  final ParentRepository _repository;

  ParentService(this._repository);

  Future<List<Parent>> getParents() async {
    return await _repository.list();
  }
}
