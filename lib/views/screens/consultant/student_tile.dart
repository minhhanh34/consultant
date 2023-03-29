import 'package:consultant/constants/const.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/class_model.dart';
import '../../../models/student_model.dart';

class StudentTile extends StatelessWidget {
  const StudentTile({
    super.key,
    required this.classRoom,
    required this.student,
  });
  final Student student;
  final Class classRoom;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(student.name),
      leading: const Avatar(
        imageUrl: defaultAvtPath,
        radius: 24,
      ),
      trailing: IconButton(
        onPressed: () => context
            .read<ClassCubit>()
            .rejectStudent(classRoom.id!, student.id!),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }
}
