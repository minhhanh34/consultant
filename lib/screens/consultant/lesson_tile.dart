import 'package:consultant/cubits/parent_class/parent_class_cubit.dart';
import 'package:consultant/utils/libs_for_main.dart';
import 'package:consultant/utils/week_day_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/lesson.dart';

class LessonTile extends StatefulWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    required this.onDismissed,
    required this.confirmDismiss,
    required this.onCommented,
  });
  final Lesson lesson;
  final Function(DismissDirection)? onDismissed;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;
  final Function(String) onCommented;

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> with WeekDayMixin {
  bool showTextField = false;
  String contentOfComment = '';
  @override
  Widget build(BuildContext context) {
    final begin = DateFormat.jm().format(widget.lesson.begin);
    final end = DateFormat.jm().format(widget.lesson.end);
    final dayString = DateFormat('dd/MM/yyyy').format(widget.lesson.begin);
    final textTheme = Theme.of(context).textTheme;
    final dayOfWeek = convertWeekDay(widget.lesson.dayOfWeek);
    final userType = AuthCubit.userType?.toLowerCase();
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
          Dismissible(
            onDismissed: widget.onDismissed,
            confirmDismiss: widget.confirmDismiss,
            background: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            key: UniqueKey(),
            direction: userType == 'consultant'
                ? DismissDirection.horizontal
                : DismissDirection.none,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nội dung: ${widget.lesson.content}',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
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
                      'Đánh giá của gia sư: ${widget.lesson.commentOfConsultant ?? "Chưa có"}',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nhận xét phụ huynh: ${widget.lesson.commentOfParent ?? "Chưa có"}',
                      style: textTheme.titleMedium,
                    ),
                    Builder(
                      builder: (context) {
                        if (!widget.lesson.isCompleted) {
                          final userType = AuthCubit.userType?.toLowerCase();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                const Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message:
                                      'Chờ xác nhận của phụ để hoàn thành buổi học',
                                  child: Icon(Icons.info),
                                ),
                                const SizedBox(width: 8),
                                const Text('Chưa hoàn thành'),
                                const Spacer(),
                                Visibility(
                                  visible: userType == 'parent' &&
                                      !widget.lesson.isCompleted,
                                  child: TextButton(
                                    onPressed: () async {
                                      bool? result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: const Text(
                                                'Xác nhận hoàn thành?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    GoRouter.of(context)
                                                        .pop(false),
                                                child: const Text('Hủy'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    GoRouter.of(context)
                                                        .pop(true),
                                                child: const Text('Có'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (result == null || !result) {
                                        return;
                                      }
                                      if (!mounted) return;
                                      context
                                          .read<ParentClassCubit>()
                                          .updateLesson(
                                            widget.lesson.id!,
                                            widget.lesson.copyWith(
                                              isCompleted: true,
                                            ),
                                          );
                                    },
                                    child: const Text('Xác nhận hoàn thành'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Đã hoàn thành',
                              style: textTheme.titleMedium,
                            ),
                          );
                        }
                      },
                    ),
                    Visibility(
                      visible: showTextField,
                      child: TextField(
                        onChanged: (value) => contentOfComment = value,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Builder(
                        builder: (context) {
                          bool consultantUncommented =
                              AuthCubit.userType?.toLowerCase() ==
                                      'consultant' &&
                                  widget.lesson.commentOfConsultant == null;
                          bool parentUncommented =
                              AuthCubit.userType?.toLowerCase() == 'parent' &&
                                  widget.lesson.commentOfParent == null;
                          bool uncommented =
                              consultantUncommented || parentUncommented;
                          if (uncommented) {
                            if (showTextField) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showTextField = false;
                                      });
                                    },
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showTextField = false;
                                      });
                                      widget.onCommented(contentOfComment);
                                    },
                                    child: const Text('Thêm'),
                                  ),
                                ],
                              );
                            }
                            return TextButton(
                              onPressed: () {
                                setState(() {
                                  showTextField = true;
                                });
                              },
                              child: const Text('Thêm đánh giá'),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
