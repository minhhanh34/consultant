import 'package:consultant/repositories/repository_interface.dart';
import 'package:consultant/repositories/repository_with_subcollection.dart';
import 'package:consultant/utils/libs_for_main.dart';

abstract class ParentService {
  Future<List<Parent>> getParents();
  Future<Parent> getParentByUid(String uid);
  Future<Parent> get(String id);
  Future<bool> updateParent(String id, Parent newParent);
  Future<void> rateConsultant(String classId, double rate, String? content);
}

class ParentServiceIml extends ParentService {
  final Repository<Parent> _parentRepository;
  final RepositoryWithSubCollection<Comment> _commentRepository;
  ParentServiceIml(this._parentRepository, this._commentRepository);

  @override
  Future<List<Parent>> getParents() async {
    return await _parentRepository.list();
  }

  @override
  Future<Parent> getParentByUid(String uid) async {
    final snap =
        await _parentRepository.collection.where('uid', isEqualTo: uid).get();
    return Parent.fromJson(snap.docs.first.data() as Map<String, dynamic>)
        .copyWith(id: snap.docs.first.id);
  }

  @override
  Future<Parent> get(String id) async {
    return await _parentRepository.getOne(id) as Parent;
  }

  @override
  Future<bool> updateParent(String id, Parent newParent) async {
    bool result = await _parentRepository.update(id, newParent);
    if (result) {
      AuthCubit.setInfoUpdated = true;
      await AuthCubit.userCredential?.user?.updatePhotoURL('old');
      const secureStorage = FlutterSecureStorage();
      await secureStorage.write(key: 'infoUpdated', value: 'true');
    }
    return result;
  }

  @override
  Future<void> rateConsultant(
    String classId,
    double rate,
    String? content,
  ) async {
    // _commentRepository.create(consultantId, comment);
  }
}
