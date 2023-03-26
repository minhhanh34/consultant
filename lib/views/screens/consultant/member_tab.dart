import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_class/class_state.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/screens/consultant/student_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberTab extends StatelessWidget {
  const MemberTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ClassCubit, ClassState>(
          builder: (context, state) {
            if (state is ClassDetailFethed) {
              if (state.students.isEmpty) {
                return const Center(
                  child: Text('Chưa có thành viên'),
                );
              }
              return ListView.builder(
                itemCount: state.students.length,
                itemBuilder: (context, index) {
                  return StudentTile(state.students[index]);
                },
              );
            }
            if (state is ClassLoading) return const CenterCircularIndicator();
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
