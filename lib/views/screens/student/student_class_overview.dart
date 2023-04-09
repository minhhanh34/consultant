import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/auth/auth_state.dart';
import 'package:consultant/cubits/student_home/student_home_cubit.dart';
import 'package:consultant/cubits/student_home/sutdent_home_state.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'student_home_classes.dart';

class StudentClassHome extends StatelessWidget {
  const StudentClassHome({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignOuted) {
          context.go('/SignIn');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lớp học'),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => context.read<AuthCubit>().signOut(context),
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () {
                context.push('/Enroll',
                    extra: context.read<StudentHomeCubit>().student);
              },
              leading: const Icon(Icons.add),
              title: const Text('Ghi danh lớp học mới'),
            ),
            Expanded(
              child: BlocBuilder<StudentHomeCubit, StudentHomeState>(
                builder: (context, state) {
                  if (state is StudentHomeInitial) {
                    if (AuthCubit.currentUserId != null) {
                      context
                          .read<StudentHomeCubit>()
                          .fetchClassesForStudent(AuthCubit.currentUserId!);
                    }
                  }
                  if (state is StudentHomeLoading) {
                    return const CenterCircularIndicator();
                  }
                  if (state is StudentHomeClassFetched) {
                    if (state.classes.isEmpty) {
                      return const Center(
                        child: Text('Chưa có lớp học'),
                      );
                    }
                    return StudentHomeClasses(
                      classes: state.classes,
                      student: context.read<StudentHomeCubit>().student!,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
