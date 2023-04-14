import 'package:consultant/cubits/student_class/student_class_cubit.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/models/submission_model.dart';
import 'package:consultant/services/downloader_service.dart';
import 'package:consultant/utils/select_files_bottom_sheet.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/components/file_attach_chip.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../services/firebase_storage_service.dart';

class StudentExerciseTile extends StatefulWidget {
  const StudentExerciseTile({
    super.key,
    required this.classId,
    required this.exercise,
    this.submission,
    required this.studentId,
    this.state = DownloadState.unDownload,
  });
  final Exercise exercise;
  final String studentId;
  final String classId;
  final Submission? submission;

  final DownloadState state;

  @override
  State<StudentExerciseTile> createState() => _StudentExerciseTileState();
}

class _StudentExerciseTileState extends State<StudentExerciseTile> {
  FilePickerResult? filePickerResult;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentClassCubit>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.indigo,
            blurRadius: 4,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hạn nộp: ${widget.exercise.timeIsUp != null ? DateFormat("hh:mm - dd/MM").format(widget.exercise.timeIsUp!) : "Không có"}',
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Ngày giao: ${DateFormat('hh:mm - dd/MM').format(widget.exercise.timeCreated)}'),
              ),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.exercise.title ?? ''),
          ),
          Wrap(
            children: [
              for (int i = 0; i < (widget.exercise.fileNames?.length ?? 0); i++)
                InkWell(
                  onTap: () {
                    cubit.onFilePressed(widget.exercise.fileNames![i]);
                  },
                  child: Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(widget.exercise.fileNames![i].name),
                        ),
                        buildDownloadStateIcon(
                          widget.exercise.fileNames![i].state,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Visibility(
              visible: filePickerResult != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Bài nộp đã tải lên1',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Wrap(
                    children: [
                      for (int i = 0;
                          i < (filePickerResult?.names.length ?? 0);
                          i++)
                        FileAttachChip(
                          onRemove: () {
                            filePickerResult?.files.removeAt(i);
                            if (filePickerResult!.files.isEmpty) {
                              filePickerResult = null;
                            }
                            setState(() {});
                          },
                          name: filePickerResult?.names[i] ?? '',
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Visibility(
              visible: widget.submission != null &&
                  widget.submission!.fileNames.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.black),
                  Wrap(
                    children: [
                      for (int i = 0;
                          i < (widget.submission?.fileNames.length ?? 0);
                          i++)
                        FileAttachChip(
                          enable: false,
                          onRemove: () {},
                          name: widget.submission?.fileNames[i].name ?? '',
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Builder(builder: (context) {
                      if (widget.submission == null) {
                        return const SizedBox();
                      }
                      return Text(
                        DateFormat("hh:mm - dd/MM/yyyy")
                            .format(widget.submission!.timeCreated),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Visibility(
            visible: widget.exercise.submissionEnabled,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: filePickerResult != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextButton(
                        onPressed: () async {
                          filePickerResult =
                              await SelectFilesBottomSheet.select(context);
                          setState(() {});
                        },
                        child: const Text('Chọn lại'),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.submission == null ||
                        widget.submission!.fileNames.isEmpty,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (filePickerResult != null) {
                          // context.read<StudentClassCubit>().loading();
                          List<FileName> fileNames = [];
                          final storageService = FirebaseStorageService();
                          if (filePickerResult != null) {
                            fileNames = await storageService.createFolderFiles(
                              'submissions',
                              filePickerResult!.paths,
                            );
                          }

                          if (!mounted) return;

                          for (int i = 0; i < fileNames.length; i++) {
                            fileNames[i] = fileNames[i].copyWith(
                              name: filePickerResult?.names[i] ?? '',
                            );
                          }
                          final submission = Submission(
                            timeCreated: DateTime.now(),
                            studentId: widget.studentId,
                            exerciseId: widget.exercise.id!,
                            fileNames: fileNames,
                          );
                          context.read<StudentClassCubit>().createSubmission(
                                widget.classId,
                                submission,
                              );
                          return;
                        }
                        filePickerResult =
                            await SelectFilesBottomSheet.select(context);
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: filePickerResult == null,
                            child: Row(
                              children: const [
                                Icon(Icons.add),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const Text('Nộp bài'),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.submission != null &&
                        widget.submission!.fileNames.isNotEmpty,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Đã nộp'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDownloadStateIcon(DownloadState state) {
    if (state == DownloadState.downloaded) {
      return const Icon(Icons.download_done);
    }
    if (state == DownloadState.downloading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 12,
          height: 12,
          child: CenterCircularIndicator(),
        ),
      );
    }
    return const Icon(Icons.download);
  }
}
