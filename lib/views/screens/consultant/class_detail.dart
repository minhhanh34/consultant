import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';

import 'package:consultant/models/class_model.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/screens/consultant/exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

import '../../../cubits/consultant_cubits/consultant_class/class_state.dart';
import 'exercise_addition_bottom_sheet.dart';
import 'member_tab.dart';

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
    _controller = TabController(length: 2, vsync: this);
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
              child: Text(
                'Bài tập',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Thành viên',
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Mã lớp: ${widget.classRoom.id}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: widget.classRoom.id),
                            );
                            if (!mounted) return;
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(content: Text('Đã sao chép!')),
                              );
                          },
                          icon: const Icon(Icons.copy),
                        )
                      ],
                    ),
                  ),
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
                ],
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
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemCount: state.exercises.length,
                        itemBuilder: (context, index) => ExerciseTile(
                          classId: widget.classRoom.id!,
                          exercise: state.exercises[index],
                        ),
                      );
                    }

                    return const CenterCircularIndicator();
                  },
                ),
              ),
            ],
          ),
          MemberTab(classRoom: widget.classRoom),
        ],
      ),
    );
  }
}
