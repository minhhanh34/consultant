import 'package:consultant/cubits/chat_rooms/chat_room_cubit.dart';
import 'package:consultant/models/chat_room.dart';
import 'package:consultant/models/consultant.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/messages/messages_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.partner});
  final Consultant partner;
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
          leading: Avatar(imageUrl: partner.avtPath!, radius: 25),
          title: Text(partner.name),
          subtitle: Text(partner.subjectsToString()),
        ),
      ),
      body: Stack(
        children: [
          ListView(),
          MessageField(partner: partner),
        ],
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
    return Positioned(
      bottom: 8.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      ),
    );
  }
}
