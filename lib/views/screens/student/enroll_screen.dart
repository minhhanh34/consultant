import 'package:flutter/material.dart';

class EnrollScreen extends StatefulWidget {
  const EnrollScreen({super.key});

  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  final GlobalKey<State<Tooltip>> _key = GlobalKey<State<Tooltip>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi danh lớp học'),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Nhập mã lớp học',
                prefixIcon: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  key: _key,
                  message: 'Mã lớp học được cung cấp từ giáo viên của bạn',
                  child: const Icon(Icons.info),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Ghi danh'),
          ),
        ],
      ),
    );
  }
}
