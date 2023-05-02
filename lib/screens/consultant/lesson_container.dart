import 'dart:math';

import 'package:consultant/utils/libs_for_main.dart';
import 'package:flutter/material.dart';

import 'package:consultant/models/lesson.dart';

import 'lesson_overview.dart';

class LessonContainer extends StatefulWidget {
  const LessonContainer({
    super.key,
    required this.lessons,
    required this.parentId,
    required this.classId,
    required this.studentIds,
    required this.subjectName,
    required this.price,
  });
  final List<Lesson> lessons;
  final String parentId;
  final List<String> studentIds;
  final String classId;
  final String subjectName;
  final double price;
  @override
  State<LessonContainer> createState() => _LessonContainerState();
}

class _LessonContainerState extends State<LessonContainer> {
  TimeOfDay? begin;
  TimeOfDay? end;
  String lessonContent = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => addNewLesson(context),
          leading: const Icon(Icons.add_circle),
          title: const Text('Thêm buổi học'),
        ),
        Expanded(
          child: LessonOverView(
            onRefresh: () async =>
                context.read<ClassCubit>().refreshLessosn(widget.classId),
            lessons: widget.lessons,
          ),
        ),
      ],
    );
  }

  void addNewLesson(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    late PersistentBottomSheetController bottomSheetController;
    bottomSheetController = showBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Thêm buổi học',
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Không được bỏ trống';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Nội dung buổi học',
                      ),
                      onChanged: (value) => lessonContent = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          'Thời gian bắt đầu: ',
                          style: textTheme.titleMedium,
                        ),
                        Text(
                          begin?.format(context) ?? '',
                          style: textTheme.titleMedium,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            begin = await pickTime(context);
                            bottomSheetController.setState!(() {});
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          'Thời gian kết thúc: ',
                          style: textTheme.titleMedium,
                        ),
                        Text(
                          end?.format(context) ?? '',
                          style: textTheme.titleMedium,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            end = await pickTime(context);
                            bottomSheetController.setState!(() {});
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        bool? result = _formKey.currentState?.validate();
                        if (result == false) return;
                        if (begin == null || end == null) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text('Không được bỏ trống thời gian'),
                              ),
                            );
                          return;
                        }
                        DateTime lessonBegin = DateTime.now().copyWith(
                          hour: begin?.hour,
                          minute: begin?.minute,
                        );
                        DateTime lessonEnd = DateTime.now().copyWith(
                          hour: end?.hour,
                          minute: end?.minute,
                        );
                        int duration = ((lessonEnd.microsecondsSinceEpoch -
                                lessonBegin.microsecondsSinceEpoch) ~/
                            pow(10, -6));
                        final lesson = Lesson(
                          price: widget.price,
                          content: lessonContent,
                          isCompleted: false,
                          begin: lessonBegin,
                          end: lessonEnd,
                          dayOfWeek: lessonBegin.weekday,
                          duration: duration,
                          consultantId: AuthCubit.currentUserId!,
                          parentId: widget.parentId,
                          studentIds: widget.studentIds,
                          classId: widget.classId,
                          subjectName: widget.subjectName,
                        );
                        context.read<ClassCubit>().createLesson(lesson);
                        context.pop();
                      },
                      child: const Text('Thêm'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }
}
