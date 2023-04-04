import 'package:consultant/cubits/posts/post_state.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/posts/post_cubit.dart';
import 'parent_posted_tile.dart';

class PostedContainer extends StatelessWidget {
  const PostedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Bài đã đăng',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostInitial) {
            context.read<PostCubit>().onPosted();
          }
          if (state is PostLoading) {
            return const CenterCircularIndicator();
          }
          if (state is PostFetched) {
            if (state.posts.isEmpty) {
              return Center(
                child: Text(
                  'Chưa có bài đăng',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: state.posts.length,
              itemBuilder: (context, index) => ParentPostedTile(
                post: state.posts[index],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
