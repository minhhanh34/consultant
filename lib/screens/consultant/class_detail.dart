import 'package:consultant/cubits/consultant_class/class_cubit.dart';

import 'package:consultant/models/class_model.dart';
import 'package:consultant/widgets/center_circular_indicator.dart';
import 'package:consultant/screens/consultant/exercise_tile.dart';
import 'package:consultant/screens/consultant/information_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

import '../../cubits/consultant_class/class_state.dart';
import 'exercise_addition_bottom_sheet.dart';
import 'lesson_container.dart';

class ClassDetail extends StatefulWidget {
  const ClassDetail({Key? key, required this.classRoom}) : super(key: key);
  final Class classRoom;
  @override
  State<ClassDetail> createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  final _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ClassCubit>();
    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.classRoom.name),
        bottom: TabBar(
          indicatorColor: Colors.orange,
          indicatorWeight: 5,
          controller: _controller,
          tabs: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Buổi học'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Bài tập',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Thông tin',
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          /// lesson tap
          BlocBuilder<ClassCubit, ClassState>(
            builder: (context, state) {
              if (state is ClassInitial) {
                context
                    .read<ClassCubit>()
                    .fetchDetailClass(widget.classRoom.id!);
              }
              if (state is ClassLoading) {
                return const CenterCircularIndicator();
              }
              if (state is ClassDetailFethed) {
                return LessonContainer(
                  lessons: state.lessons,
                  parentId: widget.classRoom.parentId,
                  classId: widget.classRoom.id!,
                  studentIds: widget.classRoom.studentIds,
                  subjectName: widget.classRoom.subject.name,
                );
              }
              return const SizedBox();
            },
          ),

          /// exercise tap
          Column(
            children: [
              ListTile(
                onTap: () async {
                  _key.currentState?.showBottomSheet(
                    (context) => ExerciseAdditionBottomSheet(
                      classRoom: widget.classRoom,
                      scaffoldKey: _key,
                    ),
                  );
                },
                leading: const Icon(Icons.add_circle),
                title: const Text('Thêm bài tập mới'),
              ),
              Expanded(
                child: BlocConsumer<ClassCubit, ClassState>(
                  listener: (context, state) {
                    if (state is OpenExerciseAttachFile) {
                      OpenFilex.open(state.path);
                    }
                  },
                  builder: (context, state) {
                    if (state is ClassInitial) {
                      cubit.fetchDetailClass(widget.classRoom.id!);
                    }
                    if (state is ClassLoading) {
                      return const CenterCircularIndicator();
                    }
                    if (state is ClassDetailFethed) {
                      if (state.exercises.isEmpty) {
                        return const Center(
                          child: Text('Chưa có bài tập'),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async => context
                            .read<ClassCubit>()
                            .refreshExercises(widget.classRoom.id!),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemCount: state.exercises.length,
                          itemBuilder: (context, index) {
                            return ExerciseTile(
                              classId: widget.classRoom.id!,
                              exercise: state.exercises[index],
                              submissions: state.submissions
                                  .where((submission) =>
                                      submission.exerciseId ==
                                      state.exercises[index].id!)
                                  .toList(),
                            );
                          },
                        ),
                      );
                    }
                    return const CenterCircularIndicator();
                  },
                ),
              ),
            ],
          ),
          InformationTab(classRoom: widget.classRoom),
        ],
      ),
    );
  }
}
