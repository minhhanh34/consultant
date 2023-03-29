import 'package:consultant/cubits/posts/post_state.dart';
import 'package:consultant/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post_model.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this._service) : super(PostInitial());
  final PostService _service;
  List<Post>? _posts;
  Future<Post> createPost(Post post) async {
    return await _service.createPost(post);
  }

  Future<void> fetchPosts() async {
    emit(PostLoading());
    _posts ??= await _service.list();
    emit(PostFetched(_posts!));
  }

  void dispose() {
    _posts = null;
    emit(PostInitial());
  }

}