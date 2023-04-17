import 'package:flutter/material.dart';

import '../../../models/consultant_model.dart';

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
