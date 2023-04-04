import 'package:consultant/models/post_model.dart';
import 'package:consultant/repositories/post_repository.dart';

class PostService {
  final PostRepository _repository;
  PostService(this._repository);

  Future<Post> createPost(Post post) async {
    return await _repository.create(post);
  }

  Future<List<Post>> list() async {
    return await _repository.list();
  }

  Future<List<Post>> fetchParentPosted(String id) async {
    final snaps =
        await _repository.collection.where('posterId', isEqualTo: id).get();
    return snaps.docs.map((snap) {
      return Post.fromJson(snap.data() as Map<String, dynamic>)
          .copyWith(id: snap.id);
    }).toList();
  }

  Future<bool> delete(String id) async {
    return await _repository.delete(id);
  }
}
