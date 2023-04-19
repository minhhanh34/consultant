import 'package:consultant/constants/consts.dart';
import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ConsultantProfile extends StatefulWidget {
  const ConsultantProfile({Key? key, required this.consultant})
      : super(key: key);
  final Consultant consultant;

  @override
  State<ConsultantProfile> createState() => _ConsultantProfileState();
}

class _ConsultantProfileState extends State<ConsultantProfile> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: size.width * .08),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Avatar(
                        imageUrl: widget.consultant.avtPath ?? defaultAvtPath,
                        radius: 56,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.consultant.name,
                        style: style,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.consultant.phone,
                        style: style,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      context.push(
                        '/ConsultantUpdate',
                        extra: widget.consultant,
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              onTap: () => context.push('/Map',
                  extra: widget.consultant.address.geoPoint),
              leading: const Icon(Icons.location_on, color: Colors.indigo),
              title: Text(widget.consultant.address.city),
              subtitle: Text(widget.consultant.address.district),
              trailing: const Icon(Icons.map, color: Colors.indigo),
            ),
            ListTile(
              leading: const Icon(Icons.cake, color: Colors.indigo),
              title: Text(
                DateFormat('dd/MM/yyyy').format(
                  widget.consultant.birthDay ?? DateTime(1970),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.subject, color: Colors.indigo),
              title: Text(widget.consultant.subjectsToString()),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.indigo),
              title: Builder(builder: (context) {
                if (widget.consultant.rate == null) {
                  return const Text('Chưa có đánh giá');
                }
                return Text(widget.consultant.rate.toString());
              }),
            ),
            ListTile(
              leading: const Icon(Icons.rate_review, color: Colors.indigo),
              title: Builder(builder: (context) {
                if (widget.consultant.comments.isEmpty) {
                  return const Text('Chưa có lượt đánh giá nào');
                }
                return Text('${widget.consultant.raters} đánh giá');
              }),
              trailing: Builder(builder: (context) {
                if (widget.consultant.comments.isEmpty) {
                  return const SizedBox();
                }
                return const Icon(Icons.arrow_forward_ios);
              }),
            ),
            ListTile(
              onTap: () async {
                bool isSignOut = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text(
                        'Bạn có chắc muốn đăng xuất?',
                      ),
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
                if (!mounted) return;
                if (isSignOut) {
                  context.read<AuthCubit>().signOut(context);
                }
              },
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
