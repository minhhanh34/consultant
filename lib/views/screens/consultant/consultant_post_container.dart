import 'package:consultant/cubits/posts/post_cubit.dart';
import 'package:consultant/cubits/posts/post_state.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/screens/consultant/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultantPostContainer extends StatelessWidget {
  const ConsultantPostContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài đăng'),
        elevation: 0,
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostInitial) {
            cubit.fetchPosts();
          }
          if (state is PostFetched) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostTile(post: state.posts[index]);
              },
            );
          }
          if (state is PostLoading) {
            return const CenterCircularIndicator();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
