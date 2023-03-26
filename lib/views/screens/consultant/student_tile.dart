import 'package:consultant/constants/const.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';

import '../../../models/student_model.dart';

class StudentTile extends StatelessWidget {
  const StudentTile(this.student, {super.key});
  final Student student;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(student.name),
      leading: const Avatar(
        imageUrl: defaultAvtPath,
        radius: 24,
      ),
    );
  }
}
