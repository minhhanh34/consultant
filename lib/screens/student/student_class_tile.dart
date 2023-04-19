import 'package:consultant/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/class_model.dart';
import '../../models/student_model.dart';

class StudentClassTile extends StatelessWidget {
  const StudentClassTile(this.sclass, this.student, {super.key});
  final Class sclass;
  final Student student;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(
        '/StudentClass',
        extra: {
          'classId': sclass.id,
          'studentId': student.id,
        },
      ),
      leading: Avatar(
        imageUrl: sclass.avtPath,
        radius: 24.0,
      ),
      title: Text(sclass.name),
      subtitle: Text(sclass.subject.name),
    );
  }
}
