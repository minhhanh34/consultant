import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/services/downloader_service.dart';
import 'package:consultant/services/firebase_storage_service.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExerciseTile extends StatefulWidget {
  const ExerciseTile({
    super.key,
    required this.exercise,
    this.state = DownloadState.unDownload,
  });
  final Exercise exercise;
  final DownloadState state;
  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ClassCubit>();
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        if (widget.exercise.fileNames != null) {
          final storageRef = FirebaseStorageService();
          for (var fileName in widget.exercise.fileNames!) {
            storageRef.deleteFile(fileName.storageName);
          }
        }
        context
            .read<ClassCubit>()
            .deleteExcercise('3va8glsR7Gl3suoLE5Wz', widget.exercise);
      },
      background: Container(
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Xác nhận xóa'),
              content: const Text('Bạn có chắc muốn xóa?'),
              actions: [
                TextButton(
                  onPressed: () => GoRouter.of(context).pop(true),
                  child: const Text('Có'),
                ),
                TextButton(
                  onPressed: () => GoRouter.of(context).pop(false),
                  child: const Text('Không'),
                )
              ],
            );
          },
        );
      },
      child: Container(
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
            ]),
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
                for (int i = 0;
                    i < (widget.exercise.fileNames?.length ?? 0);
                    i++)
                  InkWell(
                    onTap: () {
                      cubit.onFilePressed(widget.exercise.fileNames![i]);
                    },
                    child: Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.exercise.fileNames![i].name),
                          buildDownloadStateIcon(
                            widget.exercise.fileNames![i].state,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
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
