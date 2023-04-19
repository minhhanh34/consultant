import 'package:consultant/utils/week_day_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/lesson.dart';

class LessonTile extends StatelessWidget with WeekDayMixin {
  const LessonTile({super.key, required this.lesson});
  final Lesson lesson;
  @override
  Widget build(BuildContext context) {
    final begin = DateFormat.jm().format(lesson.begin);
    final end = DateFormat.jm().format(lesson.begin);
    final dayString = DateFormat('dd/MM/yyyy').format(lesson.begin);
    final textTheme = Theme.of(context).textTheme;
    final dayOfWeek = convertWeekDay(lesson.dayOfWeek);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$dayOfWeek, ',
                style: textTheme.titleMedium,
              ),
              Text(
                dayString,
                style: textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'bắt đầu: $begin',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'kết thúc: $end',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đánh giá của gia sư: ${lesson.commentOfConsultant ?? "Chưa có"}',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nhận xét phụ huynh: ${lesson.commentOfParent ?? "Chưa có"}',
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
