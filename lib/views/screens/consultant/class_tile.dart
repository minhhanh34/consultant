import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/models/class_model.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class ClassTile extends StatelessWidget {
  const ClassTile({super.key, required this.consultantClass});
  final Class consultantClass;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConsultantHomeCubit>();
    final scaffoldMesenger = ScaffoldMessenger.of(context);
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: .2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              bool confirm = await showDialog(
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
              if (!confirm) return;
              bool deleted = await cubit.deleteClass(consultantClass);
              if (deleted) {
                scaffoldMesenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Đã xóa ${consultantClass.name}')),
                  );
              }
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => context.push('/ClassDetail', extra: consultantClass),
        leading: Avatar(
          imageUrl: consultantClass.avtPath,
          radius: 24.0,
        ),
        title: Text(consultantClass.name),
        subtitle: Text('Môn ${consultantClass.subject.name}'),
        trailing: Text('Số lượng\n      ${consultantClass.studentSize}'),
      ),
    );
  }
}
