import 'package:consultant/cubits/posts/post_cubit.dart';
import 'package:consultant/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ParentPostedTile extends StatelessWidget {
  const ParentPostedTile({super.key, required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => postCubit.deletePosted(post),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text('Bạn có chắc muốn xóa bài đăng?'),
              actions: [
                TextButton(
                  onPressed: () => GoRouter.of(context).pop(true),
                  child: const Text('Có'),
                ),
                TextButton(
                  onPressed: () => GoRouter.of(context).pop(false),
                  child: const Text('Không'),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: Colors.indigo,
        child: ListTile(
          title: Text(DateFormat('hh:mm - dd/MM').format(post.time)),
          subtitle: Text(post.content),
        ),
      ),
    );
  }
}
