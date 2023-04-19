import 'package:consultant/constants/consts.dart';
import 'package:consultant/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';

import '../../models/class_model.dart';
import '../../models/student_model.dart';

class StudentTile extends StatefulWidget {
  const StudentTile({
    super.key,
    required this.classRoom,
    required this.student,
  });
  final Student student;
  final Class classRoom;
  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.student.name),
      leading: const Avatar(
        imageUrl: defaultAvtPath,
        radius: 24,
      ),
    );
  }
}
