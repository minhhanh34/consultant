
import 'package:consultant/models/lesson.dart';
import 'package:flutter/material.dart';
import 'lesson_tile.dart';

class LessonOverView extends StatefulWidget {
  const LessonOverView({super.key, required this.lessons});
  final List<Lesson> lessons;

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
        return ListView.builder(
          itemCount: widget.lessons.length,
          itemBuilder: (context, index) {
            return LessonTile(lesson: widget.lessons[index]);
          },
        );
      },
    );
  }
}
