import 'package:consultant/cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/consultant_class/class_state.dart';
import 'package:consultant/models/class_model.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InformationTab extends StatelessWidget {
  const InformationTab({
    super.key,
    required this.classRoom,
  });
  final Class classRoom;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildClassAvatar(),
            buildClassId(context),
            buildConsultantInfo(),
            buildMembersTile(context),
            buildSubjectInfo(context),
          ],
        ),
      ),
    );
  }

  buildMembersTile(BuildContext context) {
    final students = <Student>[];
    return ListTile(
      onTap: () => context.push(
        '/ConsultantClassStudents',
        extra: {
          'students': students,
          'classRoom': classRoom,
        },
      ),
      title: const Text('Số lượng thành viên'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<ClassCubit, ClassState>(
            builder: (context, state) {
              if (state is ClassDetailFethed) {
                students.addAll(state.students);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.students.length.toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    Visibility(
                      visible: state.students.isNotEmpty,
                      child: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                );
              }
              return Text(
                0.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              );
            },
          ),
        ],
      ),
    );
  }

  buildConsultantInfo() {
    return ListTile(
      title: const Text('Giáo viên'),
      trailing: Text(classRoom.consultantName),
    );
  }

  buildClassId(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: const Text('Mã lớp'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            classRoom.id!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: classRoom.id),
              );
              scaffoldMessenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Đã sao chép!')),
                );
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }

  buildSubjectInfo(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Môn'),
          trailing: Text(classRoom.subject.name, style: style),
        ),
        ListTile(
          title: const Text('Lớp'),
          trailing: Text('${classRoom.subject.grade}', style: style),
        ),
        ListTile(
          title: const Text('Thời gian'),
          trailing:
              Text('${classRoom.subject.duration} phút/buổi', style: style),
        ),
        ListTile(
          title: const Text('Giờ bắt đầu'),
          trailing: Text(classRoom.subject.time, style: style),
        ),
        ListTile(
          title: const Text('Các ngày'),
          trailing: Text(classRoom.subject.dateToString(), style: style),
        ),
        ListTile(
          title: const Text('Giá'),
          trailing: Text(
              NumberFormat.simpleCurrency(locale: 'vi')
                  .format(classRoom.subject.price),
              style: style),
        ),
      ],
    );
  }

  buildClassAvatar() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Avatar(
          imageUrl: classRoom.avtPath,
          radius: 48,
        ),
      ),
    );
  }
}

