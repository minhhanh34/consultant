import 'package:consultant/constants/consts.dart';
import 'package:consultant/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class ChildrensScreen extends StatelessWidget {
  const ChildrensScreen({super.key, required this.children});
  final List<Student> children;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Con của tôi'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Avatar(
              imageUrl: defaultAvtPath,
              radius: 24.0,
            ),
            title: Text(children[index].name),
          );
        },
      ),
    );
  }
}
