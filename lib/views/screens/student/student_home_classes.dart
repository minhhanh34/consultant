import 'package:flutter/material.dart';

import '../../../models/class_model.dart';
import '../../../models/student_model.dart';
import 'student_class_tile.dart';

class StudentHomeClasses extends StatelessWidget {
  const StudentHomeClasses({
    super.key,
    required this.classes,
    required this.student,
  });
  final List<Class> classes;
  final Student student;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        return StudentClassTile(classes[index], student);
      },
    );
  }
}
