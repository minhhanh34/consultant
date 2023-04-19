import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/post_model.dart';

class PostTile extends StatefulWidget {
  const PostTile({super.key, required this.post});
  final Post post;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            blurStyle: BlurStyle.outer,
            color: Colors.indigo,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Avatar(
              imageUrl: widget.post.posterAvtPath,
              radius: 24,
            ),
            title: Text(widget.post.posterName),
            subtitle:
                Text(DateFormat('hh:mm - dd/MM').format(widget.post.time)),
            trailing: InkWell(
              onTap: () async {
                final room = ChatRoom(
                  firstPersonId: AuthCubit.currentUserId!,
                  secondPersonId: widget.post.posterId,
                );
                final roomAfterCheck =
                    await context.read<MessageCubit>().checkRoom(context, room);
                if (!mounted) return;
                // todo
                context.push(
                  '/ChatRoom',
                  extra: {
                    'partnerId': room.secondPersonId,
                    'room': roomAfterCheck,
                  },
                );
              },
              child: const Icon(
                Icons.chat_bubble,
                color: Colors.indigo,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(widget.post.content),
          ),
        ],
      ),
    );
  }
}
