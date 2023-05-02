import 'package:consultant/constants/consts.dart';
import 'package:consultant/cubits/auth/auth_state.dart';
import 'package:consultant/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/auth/auth_cubit.dart';
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
  Future<void> _onSignOut() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Bạn có chắc muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => GoRouter.of(context).pop(true),
              child: const Text('Có'),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).pop(false),
              child: const Text('Không'),
            ),
          ],
        );
      },
    );
    if (confirm ?? false) {
      signOut();
    }
  }

  void signOut() {
    context.read<AuthCubit>().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignOuted) {
          context.go('/SignIn');
        }
      },
      child: Drawer(
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
            ListTile(
              onTap: _onSignOut,
              title: Text('Đăng xuất', style: textTheme.titleMedium),
              trailing: const Icon(Icons.logout, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
