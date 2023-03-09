import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/cubits/messages/messages_state.dart';
import 'package:consultant/models/chat_room.dart';
import 'package:consultant/models/consultant.dart';
import 'package:consultant/models/message.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.partner, required this.room});
  final Consultant partner;
  final ChatRoom room;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];

  Future<void> sendMessage(String content) async {
    final message = Message(
      time: DateTime.now(),
      content: content,
      senderId: '123',
      receiverId: widget.partner.id!,
      seen: false,
    );
    await context.read<MessageCubit>().createMessage(widget.room.id!, message);
    // messages.add(newMessage);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.pop(),
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
          leading: Avatar(imageUrl: widget.partner.avtPath!, radius: 25),
          title: Text(widget.partner.name),
          subtitle: Text(widget.partner.subjectsToString()),
        ),
      ),
      body: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          if (state is MessageInitial) {
            context.read<MessageCubit>().fetchMessages(widget.room);
          }
          if (state is MessageFatched) {
            return Column(
              children: [
                Expanded(
                  child: ChatBubbles(
                    room: widget.room,
                    messages: state.messages,
                    partner: widget.partner,
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
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ChatBubbles extends StatefulWidget {
  const ChatBubbles({super.key, required this.room, required this.messages, required this.partner,});
  final List<Message> messages;
  final Consultant partner;
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
    final messageCubit = context.read<MessageCubit>();
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
      messageCubit.recallMessage(
        'vLE5iPPgCcL4FRnHj6mN',
        widget.messages[messageIndex].id!,
        widget.messages[messageIndex].copyWith(recall: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 8.0),
      reverse: true,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              onPressed: (context) => showAlert(
                context: context,
                roomId: widget.room.id!,
                messageIndex: index,
              ),
              label: 'Thu hồi',
              icon: Icons.undo,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40.0),
          child: Builder(builder: (context) {
            if (widget.messages[index].recall) {
              return Opacity(
                opacity: .5,
                child: BubbleNormal(
                  isSender:
                      widget.messages[index].senderId != widget.partner.id,
                  text: 'Tin nhắn đã được thu hồi',
                  tail: false,
                  color: Colors.grey.shade300,
                ),
              );
            }
            return BubbleNormal(
              isSender: widget.messages[index].senderId != widget.partner.id,
              text: widget.messages[index].content,
              color: Colors.grey.shade300,
              tail: false,
              // sent: true,
            );
          }),
        ),
      ),
    );
  }
}

class MessageField extends StatefulWidget {
  const MessageField({super.key, required this.partner});
  final Consultant partner;
  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> sendMessage(BuildContext context) async {
    if (_controller.text.isEmpty) return;
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 40.0,
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 8),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () => sendMessage(context),
            child: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 4.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }
}
