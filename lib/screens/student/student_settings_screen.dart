import 'package:consultant/cubits/student_home/student_home_cubit.dart';
import 'package:consultant/cubits/student_home/sutdent_home_state.dart';
import 'package:consultant/screens/student/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../models/student_model.dart';

class StudentSettingsScreen extends StatefulWidget {
  const StudentSettingsScreen({
    super.key,
    required this.student,
    required this.drawer,
  });
  final Student student;
  final StudentDrawer drawer;

  @override
  State<StudentSettingsScreen> createState() => _StudentSettingsScreenState();
}

class _StudentSettingsScreenState extends State<StudentSettingsScreen> {
  final List<Map<String, dynamic>> items = [
    {
      'label': 'Lớp học',
      'selected': false,
    },
    {
      'label': 'Cài đặt',
      'selected': true,
    }
  ];

  late Map<String, dynamic> studentData;

  void onTap(Map<String, dynamic> item) {
    final StudentHomeCubit studentHomeCubit = context.read<StudentHomeCubit>();
    if (item['label'] == 'Lớp học') {
      studentHomeCubit.onClassTap();
    } else {
      studentHomeCubit.onSettingTap();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentHomeCubit>();
    const Color iconColor = Colors.indigo;
    const double minLeadingWidth = 36.0;
    const String name = 'Tên';
    const String gender = 'Giới tính';
    const String grade = 'Lớp';
    const String location = 'Vị trí';
    return BlocListener<StudentHomeCubit, StudentHomeState>(
      listener: (context, state) {
        if (state is StudentHome) {
          context.go('/Student');
        }
        if (state is StudentHomeUpdate) {
          context.push('/StudentUpdate', extra: {
            'student': state.student,
            'isFirstUpdate': false,
          });
        }
      },
      child: Scaffold(
        drawer: StudentDrawer(
          student: widget.student,
          items: items,
          onTap: onTap,
        ),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('Thông tin cá nhân'),
          actions: [
            IconButton(
              onPressed: cubit.onUpdate,
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                iconColor: iconColor,
                minLeadingWidth: minLeadingWidth,
                leading: const Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: name,
                  child: Icon(FontAwesomeIcons.addressCard),
                ),
                title: Text(widget.student.name),
              ),
              ListTile(
                iconColor: iconColor,
                minLeadingWidth: minLeadingWidth,
                leading: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: gender,
                  child: Icon(
                    widget.student.gender == 'Nam' ? Icons.male : Icons.female,
                    size: 28.0,
                  ),
                ),
                title: Text(widget.student.gender),
              ),
              ListTile(
                iconColor: iconColor,
                minLeadingWidth: minLeadingWidth,
                leading: const Tooltip(
                  message: grade,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(FontAwesomeIcons.userGraduate),
                ),
                title: Text(widget.student.grade.toString()),
              ),
              ListTile(
                iconColor: iconColor,
                minLeadingWidth: minLeadingWidth,
                leading: const SizedBox(
                  width: 36.0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Tooltip(
                      message: location,
                      triggerMode: TooltipTriggerMode.tap,
                      child: Icon(FontAwesomeIcons.locationDot),
                    ),
                  ),
                ),
                title: Text(widget.student.address.city),
                subtitle: Text(widget.student.address.district),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
