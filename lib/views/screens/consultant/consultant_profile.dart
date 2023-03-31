import 'package:consultant/constants/const.dart';
import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ConsultantProfile extends StatelessWidget {
  const ConsultantProfile({Key? key, required this.consultant})
      : super(key: key);
  final Consultant consultant;
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
                        imageUrl: consultant.avtPath ?? defaultAvtPath,
                        radius: 56,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        consultant.name,
                        style: style,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        consultant.phone,
                        style: style,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 8,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              onTap: () =>
                  context.push('/Map', extra: consultant.address.geoPoint),
              leading: const Icon(Icons.location_on, color: Colors.indigo),
              title: Text(consultant.address.city),
              subtitle: Text(consultant.address.district),
              trailing: const Icon(Icons.map, color: Colors.indigo),
            ),
            ListTile(
              leading: const Icon(Icons.cake, color: Colors.indigo),
              title: Text(
                DateFormat('dd/MM/yyyy').format(
                  consultant.birthDay ?? DateTime(1970),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.subject, color: Colors.indigo),
              title: Text(consultant.subjectsToString()),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.indigo),
              title: Text(consultant.rate.toString()),
            ),
            ListTile(
              leading: const Icon(Icons.rate_review, color: Colors.indigo),
              title: Text('${consultant.rate} đánh giá'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () => context.read<AuthCubit>().signOut(context),
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
