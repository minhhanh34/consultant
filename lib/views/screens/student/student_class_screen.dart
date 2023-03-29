import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/screens/student/student_exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

import '../../../cubits/student_class/student_class_cubit.dart';
import '../../../cubits/student_class/student_class_state.dart';

class StudentClassScreen extends StatelessWidget {
  const StudentClassScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập'),
        elevation: 0,
      ),
      body: BlocConsumer<StudentClassCubit, StudentClassState>(
        listener: (context, state) {
          if(state is StudentClassOpenFile) {
            OpenFilex.open(state.path);
          }
        },
        builder: (context, state) {
          if (state is StudentClassInitlal) {
            context.read<StudentClassCubit>().fetchExercises(id);
          }
          if (state is StudentClassLoading) {
            return const CenterCircularIndicator();
          }
          if (state is StudentClassExerciseFetched) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: state.exercises.length,
              itemBuilder: (context, index) => StudentExerciseTile(
                classId: id,
                exercise: state.exercises[index],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
