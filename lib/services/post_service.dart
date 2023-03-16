import 'package:consultant/models/post_model.dart';
import 'package:consultant/repositories/post_repository.dart';

class PostService {
  final PostRepository _repository;
  PostService(this._repository);

  Future<Post> createPost(Post post) async {
    return await _repository.create(post);
  }
  
}