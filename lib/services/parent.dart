import '../models/parent.dart';
import '../repositories/parent_repository.dart';

class ParentService {
  final ParentRepository repository;

  ParentService(this.repository);

  Future<List<Parent>> getParents() async {
    return await repository.list();
  }
}
