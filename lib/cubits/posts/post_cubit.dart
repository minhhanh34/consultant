import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/posts/post_state.dart';
import 'package:consultant/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post_model.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this._service) : super(PostInitial());
  final PostService _service;
  List<Post>? _posts;
  Future<void> createPost(Post post) async {
    final newPost = await _service.createPost(post);
    _posts ??= await _service.fetchParentPosted(AuthCubit.currentUserId!);
    _posts!.add(newPost);
  }

  Future<void> fetchPosts() async {
    emit(PostLoading());
    _posts ??= await _service.list();
    emit(PostFetched(_posts!));
  }

  Future<void> refresh() async {
    if (AuthCubit.userType!.toLowerCase() == 'consultant') {
      _posts = null;
      await fetchPosts();
    } else {
      _posts = null;
      await onPosted();
    }
  }

  Future<void> onPosted() async {
    emit(PostLoading());
    _posts ??= await _service.fetchParentPosted(AuthCubit.currentUserId!);
    emit(PostFetched(_posts!));
  }

  Future<void> deletePosted(Post post) async {
    await _service.delete(post.id!);
  }

  void dispose() {
    _posts = null;
    emit(PostInitial());
  }
}
