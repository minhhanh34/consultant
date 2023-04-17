import 'package:consultant/cubits/student_home/student_home_cubit.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/models/submission_model.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'consultant_class_submission_tile.dart';

class ConsultantClassSubmissionsScreen extends StatelessWidget {
  const ConsultantClassSubmissionsScreen({
    super.key,
    required this.submissions,
    required this.classId,
  });
  final List<Submission> submissions;
  final String classId;
  Future<List<Student>> fetchStudent(
    BuildContext context,
    String classId,
  ) async {
    return await context.read<StudentHomeCubit>().fetchClassStudents(classId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài nộp'),
        elevation: 0,
      ),
      body: FutureBuilder<List<Student>>(
        future: fetchStudent(context, classId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (submissions.isEmpty) {
              return Center(
                child: Text(
                  'Chưa có bài nộp ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return ListView.builder(
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final submission = submissions[index];
                final students = snapshot.data!;
                final student = students.where((st) => st.id! == submission.studentId).first;
                final tileSubmission = submissions
                    .where((sub) => sub.studentId == student.id!)
                    .toList();
                return ConsultantClassSubmissionTile(
                  classId: classId,
                  tileSubmission: tileSubmission,
                  student: student,
                );
              },
            );
          }
          return const CenterCircularIndicator();
        },
      ),
    );
  }
}

