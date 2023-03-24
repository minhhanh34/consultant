import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({super.key, required this.exercise});
  final Exercise exercise;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        if (exercise.fileNames != null) {
          final storageRef = FirebaseStorageService();
          for (var fileName in exercise.fileNames!) {
            storageRef.deleteFile(fileName.storageName);
          }
        }
        context
            .read<ClassCubit>()
            .deleteExcercise('3va8glsR7Gl3suoLE5Wz', exercise);
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
                    'Hạn nộp: ${exercise.timeIsUp != null ? DateFormat("hh:mm - dd/MM").format(exercise.timeIsUp!) : "Không có"}',
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Ngày giao: ${DateFormat('hh:mm - dd/MM').format(exercise.timeCreated)}'),
                ),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(exercise.title ?? ''),
            ),
            Wrap(
              children: exercise.fileNames
                      ?.map(
                        (fileName) => InkWell(
                            onTap: () async {
                              final dir =
                                  await getApplicationDocumentsDirectory();
                              final taskId = await FlutterDownloader.enqueue(
                                url: fileName.url,
                                savedDir: dir.path,
                                showNotification: true,
                                openFileFromNotification: true,
                              );
                              OpenFilex.open(taskId);
                            },
                            child: Chip(label: Text(fileName.name))),
                      )
                      .toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}
