
import 'package:consultant/screens/consultant/student_tile.dart';
import 'package:flutter/material.dart';

import '../../models/class_model.dart';
import '../../models/student_model.dart';

class ConsultantClassStudentsScreen extends StatelessWidget {
  const ConsultantClassStudentsScreen({
    super.key,
    required this.classRoom,
    required this.students,
  });
  final List<Student> students;
  final Class classRoom;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Thành viên'),
      ),
      body: Builder(builder: (context) {
        if (students.isEmpty) {
          return Center(
            child: Text(
              'Chưa có thành viên',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }
        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return StudentTile(
              classRoom: classRoom,
              student: students[index],
            );
          },
        );
      }),
    );
  }
}
