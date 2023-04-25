import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/parent_class/parent_class_cubit.dart';
import 'package:consultant/models/lesson.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'lesson_tile.dart';

class LessonOverView extends StatefulWidget {
  const LessonOverView({
    super.key,
    required this.lessons,
    required this.onRefresh,
  });
  final List<Lesson> lessons;
  final AsyncCallback onRefresh;
  @override
  State<LessonOverView> createState() => _LessonOverViewState();
}

class _LessonOverViewState extends State<LessonOverView> {
  TimeOfDay? begin = TimeOfDay?.now();
  TimeOfDay? end = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (widget.lessons.isEmpty) {
          return Center(
            child: Text(
              'Chưa có buổi học nào',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: ListView.builder(
            itemCount: widget.lessons.length,
            itemBuilder: (context, index) {
              return LessonTile(
                confirmDismiss: (DismissDirection direction) async =>
                    await confirmDismiss(context),
                onDismissed: (DismissDirection direction) {
                  context
                      .read<ClassCubit>()
                      .deleteLesson(widget.lessons[index].id!);
                },
                onCommented: (content) {
                  final userType = AuthCubit.userType?.toLowerCase();
                  var lesson = widget.lessons[index];
                  if (userType == 'consultant') {
                    lesson = lesson.copyWith(
                      commentOfConsultant: content,
                    );
                    context.read<ClassCubit>().updateLesson(lesson.id!, lesson);
                  } else if (userType == 'parent') {
                    lesson = lesson.copyWith(
                      commentOfParent: content,
                    );
                    context
                        .read<ParentClassCubit>()
                        .updateLesson(lesson.id!, lesson);
                  }
                },
                lesson: widget.lessons[index],
              );
            },
          ),
        );
      },
    );
  }

  Future<bool?> confirmDismiss(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Bạn có chắc muốn xóa?'),
          actions: [
            TextButton(
              onPressed: () => GoRouter.of(context).pop(true),
              child: const Text('Có'),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).pop(false),
              child: const Text('không'),
            ),
          ],
        );
      },
    );
  }
}
