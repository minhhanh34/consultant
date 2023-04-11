import 'package:consultant/constants/const.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/student_home/student_home_cubit.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/models/submission_model.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  String? comment;
  bool visible = false;
  bool commentEditing = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.tileSubmission.isNotEmpty,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              minVerticalPadding: 24,
              isThreeLine: true,
              leading: const Avatar(
                imageUrl: defaultAvtPath,
                radius: 24,
              ),
              title: Text(
                widget.student.name,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('hh:mm - dd/MM/yyyy')
                        .format(widget.tileSubmission.first.timeCreated),
                  ),
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
                ],
              ),
            ),
            Visibility(
              visible: widget.tileSubmission.first.consultantComment != null,
              child: Builder(builder: (context) {
                if (commentEditing) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          initialValue:
                              widget.tileSubmission.first.consultantComment,
                          maxLines: 4,
                          onChanged: (value) {
                            comment = value;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Nhận xét'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (commentEditing && comment != null) {
                              if (comment!.isNotEmpty) {
                                await context.read<ClassCubit>().comment(
                                      widget.classId,
                                      widget.tileSubmission.first.id!,
                                      widget.tileSubmission.first
                                          .copyWith(consultantComment: comment),
                                    );
                                widget.tileSubmission
                                  ..insert(
                                    0,
                                    widget.tileSubmission.first
                                        .copyWith(consultantComment: comment),
                                  )
                                  ..removeLast();
                              }
                            }
                            setState(() {
                              commentEditing = false;
                            });
                          },
                          child: const Text('Cập nhật'),
                        ),
                      ],
                    ),
                  );
                }
                return Row(
                  children: [
                    const SizedBox(width: 16.0),
                    Text(
                      widget.tileSubmission.first.consultantComment ?? '',
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          commentEditing = true;
                        });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                );
              }),
            ),
            Visibility(
              visible: visible,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  maxLines: 4,
                  onChanged: (value) {
                    comment = value;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Nhận xét'),
                ),
              ),
            ),
            Visibility(
              visible: widget.tileSubmission.first.consultantComment == null,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      if (visible && comment != null) {
                        if (comment!.isNotEmpty) {
                          await context.read<ClassCubit>().comment(
                                widget.classId,
                                widget.tileSubmission.first.id!,
                                widget.tileSubmission.first
                                    .copyWith(consultantComment: comment),
                              );
                          widget.tileSubmission
                            ..insert(
                              0,
                              widget.tileSubmission.first
                                  .copyWith(consultantComment: comment),
                            )
                            ..removeLast();
                        }
                      }
                      setState(() {
                        visible = !visible;
                      });
                    },
                    child: const Text('Thêm nhận xét'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
