import 'package:consultant/cubits/parent_class/parent_class_cubit.dart';
import 'package:consultant/cubits/parent_class/parent_class_state.dart';
import 'package:consultant/screens/consultant/exercise_tile.dart';
import 'package:consultant/screens/consultant/information_tab.dart';
import 'package:consultant/screens/consultant/lesson_overview.dart';
import 'package:consultant/screens/parent/rating_consultant.dart';
import 'package:consultant/widgets/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

import '../../models/class_model.dart';

class ParentClassScreen extends StatefulWidget {
  const ParentClassScreen({super.key, required this.classroom});
  final Class classroom;
  @override
  State<ParentClassScreen> createState() => _ParentClassScreenState();
}

class _ParentClassScreenState extends State<ParentClassScreen> {
  final labels = [
    {
      'label': 'Buổi học',
      'value': true,
    },
    {
      'label': 'Bài tập',
      'value': false,
    },
    {
      'label': 'Thông tin',
      'value': false,
    },
    {
      'label': 'Đánh giá giáo viên',
      'value': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<ParentClassCubit, ParentClassState>(
      listener: (context, state) {
        if (state is ParentClassOpenFile) {
          OpenFilex.open(state.path);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text('Lớp học'),
          elevation: 0,
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: labels.map((label) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      onSelected: (value) {
                        assignLableValuesFalse();
                        label['value'] = true;
                        setState(() {});
                      },
                      backgroundColor: Colors.transparent,
                      labelStyle: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                      disabledColor: Colors.white,
                      selectedColor: Colors.indigo.shade100,
                      label: Text(label['label'] as String),
                      selected: label['value'] as bool,
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  return BlocBuilder<ParentClassCubit, ParentClassState>(
                    builder: (context, state) {
                      if (state is ParentClassInitial) {
                        context
                            .read<ParentClassCubit>()
                            .fetchClass(widget.classroom.id!);
                      }
                      if (state is ParentClassLoading) {
                        return const CenterCircularIndicator();
                      }
                      if (state is ParentClassFetched) {
                        return Builder(
                          builder: (context) {
                            if (labels.first['value'] == true) {
                              return LessonOverView(
                                lessons: state.lessons,
                                onRefresh: () => context
                                    .read<ParentClassCubit>()
                                    .fetchClass(widget.classroom.id!),
                              );
                            }
                            int second = 1;
                            int thirth = 2;
                            if (labels.elementAt(second)['value'] == true) {
                              if (state.excercises.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Chưa có bài tập',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                );
                              }
                              return RefreshIndicator(
                                onRefresh: () => context
                                    .read<ParentClassCubit>()
                                    .fetchClass(widget.classroom.id!),
                                child: ListView.builder(
                                  itemCount: state.excercises.length,
                                  itemBuilder: (context, index) {
                                    return ExerciseTile(
                                      parentMode: true,
                                      classId: widget.classroom.id!,
                                      exercise: state.excercises[index],
                                      submissions: state.submissions,
                                    );
                                  },
                                ),
                              );
                            }
                            if(labels.elementAt(thirth)['value'] == true) {
                              return InformationTab(classRoom: widget.classroom);
                            }
                            return RatingConsultant(
                              classroom: widget.classroom,
                              comment: state.comment,
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void assignLableValuesFalse() {
    labels.asMap().forEach((key, value) {
      value['value'] = false;
    });
  }
}
