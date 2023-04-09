import 'package:consultant/constants/const.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/student_home/student_home_cubit.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/models/submission_model.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ConsultantClassSubmissionsScreen extends StatelessWidget {
  const ConsultantClassSubmissionsScreen({
    super.key,
    required this.submissions,
    required this.classId,
  });
  final List<Submission> submissions;
  final String classId;
  Future<List<Student>> fetchStudent(
    BuildContext context,
    String classId,
  ) async {
    return await context.read<StudentHomeCubit>().fetchClassStudents(classId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài nộp'),
        elevation: 0,
      ),
      body: FutureBuilder<List<Student>>(
        future: fetchStudent(context, classId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (submissions.isEmpty) {
              return Center(
                child: Text(
                  'Chưa có bài nộp ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final student = snapshot.data![index];
                final tileSubmission = submissions
                    .where((sub) => sub.studentId == student.id!)
                    .toList();
                return ConsultantClassSubmissionTile(
                  classId: classId,
                  tileSubmission: tileSubmission,
                  student: student,
                );
              },
            );
          }
          return const CenterCircularIndicator();
        },
      ),
    );
  }
}

class ConsultantClassSubmissionTile extends StatefulWidget {
  const ConsultantClassSubmissionTile({
    super.key,
    required this.tileSubmission,
    required this.student,
    required this.classId,
  });

  final List<Submission> tileSubmission;
  final Student student;
  final String classId;
  @override
  State<ConsultantClassSubmissionTile> createState() =>
      _ConsultantClassSubmissionTileState();
}

class _ConsultantClassSubmissionTileState
    extends State<ConsultantClassSubmissionTile> {
  double? point;
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.tileSubmission.isNotEmpty,
      child: Card(
        child: ListTile(
          isThreeLine: true,
          leading: const Avatar(
            imageUrl: defaultAvtPath,
            radius: 24,
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.student.name,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: widget.tileSubmission.first.fileNames.map((file) {
                  return InkWell(
                    onTap: () async {
                      final dir = await getExternalStorageDirectory();
                      OpenFilex.open('${dir!.path}/${file.name}');
                    },
                    child: Chip(
                      label: Text(file.name),
                    ),
                  );
                }).toList(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: widget.tileSubmission.first.point != null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Điểm: ${widget.tileSubmission.first.point}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        if (visible && point != null) {
                          if (point! >= 0 && point! <= 10) {
                            await context.read<ClassCubit>().mark(
                                  widget.classId,
                                  widget.tileSubmission.first.id!,
                                  widget.tileSubmission.first
                                      .copyWith(point: point),
                                );
                            widget.tileSubmission
                              ..insert(
                                0,
                                widget.tileSubmission.first
                                    .copyWith(point: point),
                              )
                              ..removeLast();
                          }
                        }
                        setState(() {
                          visible = !visible;
                        });
                      },
                      child: const Text('Đánh giá'),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visible,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 88.0,
                    height: 40.0,
                    child: TextField(
                      onChanged: (value) {
                        point = double.tryParse(value);
                      },
                      // onTapOutside: (event) {
                      //   setState(() {
                      //     visible = false;
                      //   });
                      // },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: OutlineInputBorder(),
                        suffixText: '/10',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
