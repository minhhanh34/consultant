import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:consultant/constants/consts.dart';
import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/chat/chat_cubit.dart';
import 'package:consultant/cubits/chat/chat_state.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/models/message_model.dart';
import 'package:consultant/constants/user_types.dart';
import 'package:consultant/widgets/circle_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.partnerId, required this.room});
  final String partnerId;
  final ChatRoom room;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];
  late ChatCubit chatCubit;
  Future<void> sendMessage(String content) async {
    final message = Message(
      time: DateTime.now(),
      content: content,
      senderId: AuthCubit.currentUserId!,
      receiverId: widget.partnerId,
      seen: false,
    );
    context.read<ChatCubit>().createMessage(widget.room.id!, message);
    context.read<MessageCubit>().refresh();
  }

  @override
  void dispose() {
    chatCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatCubit = context.read<ChatCubit>();
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatInitial) {
          if (AuthCubit.userType?.toLowerCase() == 'consultant') {
            context
                .read<ChatCubit>()
                .fetchConsultantMessages(widget.room, widget.partnerId);
          } else if (AuthCubit.userType?.toLowerCase() == 'parent') {
            context
                .read<ChatCubit>()
                .fetchParentMessages(widget.room, widget.partnerId);
          }
        }
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ChatParentFetched) {
          final partner = state.partner;
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  context.read<MessageCubit>().refresh();
                  context.pop();
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                ),
              ),
              elevation: 1,
              backgroundColor: Theme.of(context).primaryColor,
              leadingWidth: 40.0,
              title: ListTile(
                textColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                leading: Avatar(
                    imageUrl: partner.avtPath ?? defaultAvtPath, radius: 25),
                title: Text(partner.name),
                subtitle: Text(partner.subjectsToString()),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ChatBubbles(
                    room: widget.room,
                    messages: state.messages,
                    partnerAsConsultant: partner,
                    partnerType: UserType.consultant,
                  ),
                ),
                MessageBar(
                  onSend: (value) => sendMessage(value),
                  actions: [
                    IconButton(
                      splashRadius: 32,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                // MessageField(partner: partner),
              ],
            ),
          );
        }
        if (state is ChatConsultantFetched) {
          final partner = state.partner;
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  context.read<MessageCubit>().refresh();
                  context.pop();
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                ),
              ),
              elevation: 1,
              backgroundColor: Theme.of(context).primaryColor,
              leadingWidth: 40.0,
              title: ListTile(
                textColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                leading: Avatar(imageUrl: partner.avtPath, radius: 25),
                title: Text(partner.name),
                subtitle: const Text('Phụ huynh'),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ChatBubbles(
                    room: widget.room,
                    messages: state.messages,
                    partnerAsParent: partner,
                    partnerType: UserType.parent,
                  ),
                ),
                MessageBar(
                  onSend: (value) => sendMessage(value),
                  actions: [
                    IconButton(
                      splashRadius: 32,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                // MessageField(partner: partner),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}




