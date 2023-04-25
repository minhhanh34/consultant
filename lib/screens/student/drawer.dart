import 'package:consultant/constants/consts.dart';
import 'package:consultant/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/student_model.dart';

class StudentDrawer extends StatefulWidget {
  const StudentDrawer({
    super.key,
    required this.student,
    required this.items,
    required this.onTap,
  });
  final Student student;
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onTap;
  @override
  State<StudentDrawer> createState() => _StudentDrawerState();
}

class _StudentDrawerState extends State<StudentDrawer> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Avatar(
                  imageUrl: defaultAvtPath,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.student.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          ...widget.items.map((item) {
            return ListTile(
              onTap: () {
                widget.onTap(item);
                setState(() {});
                context.pop();
              },
              selected: item['selected'],
              selectedTileColor: Colors.indigo.shade100,
              title: Text(
                item['label'],
                style: textTheme.titleMedium,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
