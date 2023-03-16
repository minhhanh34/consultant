
import '../../models/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState{}

class PostLoading extends PostState {}

class PostFetched extends PostState {
  final List<Post> posts;
  PostFetched(this.posts);
}