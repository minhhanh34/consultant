import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({super.key, required this.exercise});
  final Exercise exercise;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => context
          .read<ClassCubit>()
          .deleteExcercise('3va8glsR7Gl3suoLE5Wz', exercise),
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
      child: ListTile(
        title: Text(exercise.title ?? ''),
        subtitle: Wrap(
          children: exercise.fileUrls?.map((url) => Text(url)).toList() ?? [],
        ),
        trailing:
            Text(DateFormat('hh:mm - dd/MM').format(exercise.timeCreated)),
      ),
    );
  }
}
