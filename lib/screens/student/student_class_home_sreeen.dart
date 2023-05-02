import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/auth/auth_state.dart';
import 'package:consultant/cubits/student_home/student_home_cubit.dart';
import 'package:consultant/cubits/student_home/sutdent_home_state.dart';
import 'package:consultant/screens/student/drawer.dart';
import 'package:consultant/widgets/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'student_home_classes.dart';

class StudentClassHome extends StatefulWidget {
  const StudentClassHome({super.key});

  @override
  State<StudentClassHome> createState() => _StudentClassHomeState();
}

class _StudentClassHomeState extends State<StudentClassHome> {
  final items = [
    {
      'label': 'Lớp học',
      'selected': true,
    },
    {
      'label': 'Cài đặt',
      'selected': false,
    },
  ];

  void _onTapDrawer(BuildContext context, Map<String, dynamic> item) {
    StudentHomeCubit studentHomeCubit = context.read<StudentHomeCubit>();
    for (var it in items) {
      it['selected'] = false;
    }
    item['selected'] = true;
    if (item['label'] == 'Lớp học') {
      studentHomeCubit.onClassTap();
    } else {
      studentHomeCubit.onSettingTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignOuted) {
          context.go('/SignIn');
        }
      },
      child: BlocConsumer<StudentHomeCubit, StudentHomeState>(
        listener: (context, state) {
          if (state is StudentSettings) {
            context.go(
              '/StudentSettings',
              extra: {
                'student': state.student,
                'drawer': StudentDrawer(
                  items: items,
                  onTap: (item) => _onTapDrawer(context, item),
                  student: state.student,
                ),
              },
            );
          }
        },
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
            if (AuthCubit.infoUpdated == false) {
              context.go('/StudentUpdate', extra: {
                'student': state.student,
                'isFirstUpdate': true,
              });
              return const SizedBox();
            }
            return Scaffold(
              drawer: StudentDrawer(
                onTap: (item) => _onTapDrawer(context, item),
                items: items,
                student: state.student,
              ),
              appBar: AppBar(
                title: const Text('Lớp học'),
                elevation: 0,
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
                    child: Builder(builder: (context) {
                      if (state.classes.isEmpty) {
                        return const Center(
                          child: Text('Chưa có lớp học'),
                        );
                      }
                      return StudentHomeClasses(
                        classes: state.classes,
                        student: context.read<StudentHomeCubit>().student!,
                      );
                    }),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
