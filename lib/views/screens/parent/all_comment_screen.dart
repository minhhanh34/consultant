import 'package:consultant/models/comment_model.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key, required this.comments});
  final List<Comment> comments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: comments.length,
        itemBuilder: itemBuilder,
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final comment = comments[index];
    return ListTile(
      leading: const Avatar(
        // imageUrl: comment.commentatorAvatar,
        radius: 24.0,
      ),
      title: Text(comment.commentatorName),
      subtitle: Text(comment.content),
      trailing: SizedBox(
        width: 48.0,
        child: Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            Text(comment.rate.toString()),
          ],
        ),
      ),
    );
  }
}
