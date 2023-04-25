import 'package:consultant/models/post_model.dart';
import 'package:consultant/repositories/repository_interface.dart';

abstract class PostService {
  Future<Post> createPost(Post post);
  Future<List<Post>> list();
  Future<List<Post>> fetchParentPosted(String id);
  Future<bool> delete(String id);
}

class PostServiceIml extends PostService{
  final Repository<Post> _repository;
  PostServiceIml(this._repository);

  @override
  Future<Post> createPost(Post post) async {
    return await _repository.create(post);
  }

  @override
  Future<List<Post>> list() async {
    return await _repository.list();
  }

  @override
  Future<List<Post>> fetchParentPosted(String id) async {
    final snaps =
        await _repository.collection.where('posterId', isEqualTo: id).get();
    return snaps.docs.map((snap) {
      return Post.fromJson(snap.data() as Map<String, dynamic>)
          .copyWith(id: snap.id);
    }).toList();
  }

  @override
  Future<bool> delete(String id) async {
    return await _repository.delete(id);
  }
}
