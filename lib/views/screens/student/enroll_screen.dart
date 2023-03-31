import 'package:consultant/cubits/enroll/enroll_state.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cubits/enroll/enroll_cubit.dart';

class EnrollScreen extends StatefulWidget {
  const EnrollScreen({super.key, required this.student});
  final Student student;
  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập mã lớp học',
                prefixIcon: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: 'Mã lớp học được cung cấp từ giáo viên của bạn',
                  child: Icon(Icons.info),
                ),
              ),
            ),
          ),
          BlocConsumer<EnrollCubit, EnrollState>(
            listener: (context, state) {
              if (state is EnrollSuccess) {
                context.go(
                  '/StudentClass',
                  extra: {
                    'classId': state.classId,
                    'studentId': state.studentId,
                  },
                );
              }
            },
            builder: (context, state) {
              if (state is EnrollMessage) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (state is EnrollLoading) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CenterCircularIndicator(),
                );
              }
              return const SizedBox();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                context
                    .read<EnrollCubit>()
                    .enroll(_controller.text, widget.student);
              },
              child: const Text('Ghi danh'),
            ),
          ),
        ],
      ),
    );
  }
}
