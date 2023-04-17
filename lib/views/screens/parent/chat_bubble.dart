import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/consts.dart';
import '../../../constants/user_types.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/chat/chat_cubit.dart';
import '../../../models/chat_room_model.dart';
import '../../../models/consultant_model.dart';
import '../../../models/message_model.dart';
import '../../../models/parent_model.dart';
import '../../components/circle_avatar.dart';

class ChatBubbles extends StatefulWidget {
  const ChatBubbles({
    super.key,
    required this.room,
    required this.messages,
    this.partnerAsConsultant,
    this.partnerAsParent,
    required this.partnerType,
  });
  final List<Message> messages;
  final Consultant? partnerAsConsultant;
  final Parent? partnerAsParent;
  final UserType partnerType;
  final ChatRoom room;
  @override
  State<ChatBubbles> createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  void showAlert({
    required BuildContext context,
    required int messageIndex,
    required String roomId,
  }) async {
    final chatCubit = context.read<ChatCubit>();
    FocusManager.instance.primaryFocus?.unfocus();
    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn thu hồi?'),
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
    if (result) {
      chatCubit.recallMessage(
        AuthCubit.currentUserId!,
        widget.messages[messageIndex].id!,
        widget.messages[messageIndex].copyWith(recall: true),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 8.0),
      reverse: true,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        bool isSender =
            widget.messages[index].senderId == AuthCubit.currentUserId;
        return Slidable(
          key: UniqueKey(),
          enabled: !widget.messages[index].recall && isSender,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.15,
            children: [
              SlidableAction(
                onPressed: (context) => showAlert(
                  context: context,
                  roomId: widget.room.id!,
                  messageIndex: index,
                ),
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(24.0),
                icon: Icons.rotate_left_outlined,
                autoClose: true,
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40.0),
            child: Builder(builder: (context) {
              dynamic partner;
              if (widget.partnerType == UserType.consultant) {
                partner = widget.partnerAsConsultant;
              } else {
                partner = widget.partnerAsParent;
              }
              if (widget.messages[index].recall) {
                return Opacity(
                  opacity: .5,
                  child: BubbleNormal(
                    isSender: widget.messages[index].senderId != partner.id,
                    text: 'Tin nhắn đã được thu hồi',
                    tail: false,
                    color: Colors.grey.shade300,
                  ),
                );
              }

              if (isSender) {
                return BubbleNormal(
                  isSender: isSender,
                  text: widget.messages[index].content,
                  color: Colors.grey.shade300,
                  tail: false,
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 8),
                  Avatar(
                    imageUrl: partner.avtPath ?? defaultAvtPath,
                    radius: 16.0,
                  ),
                  BubbleNormal(
                    isSender: isSender,
                    text: widget.messages[index].content,
                    color: Colors.grey.shade300,
                    tail: false,
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}