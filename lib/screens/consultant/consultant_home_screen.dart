import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/consultant_app/consultant_app_cubit.dart';
import 'package:consultant/cubits/consultant_app/consultant_app_state.dart';
import 'package:consultant/cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/widgets/messages_container.dart';
import 'package:consultant/screens/consultant/consultant_home_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'consultant_post_container.dart';
import 'consultant_settings_container.dart';

class ConsultantHomeScreen extends StatefulWidget {
  const ConsultantHomeScreen({super.key});

  @override
  State<ConsultantHomeScreen> createState() => _ConsultantHomeScreenState();
}

class _ConsultantHomeScreenState extends State<ConsultantHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: BlocBuilder<ConsultantAppCubit, ConsultantAppState>(
            builder: (context, state) {
              if (state is ConsultantHome) {
                final id = AuthCubit.currentUserId;
                if (id != null) {
                  context.read<ConsultantHomeCubit>().initialize(context, id);
                }
                return const ConsultantHomeContainer();
              }
              if (state is ConsultantPost) {
                return const ConsultantPostContainer();
              }
              if (state is ConsultantSettings) {
                return const ConsultantSettingsContainer();
              }
              if (state is ConsultantMessage) {
                return const MessagesContainer();
              }
              return const SizedBox();
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey.shade700,
            selectedItemColor: Colors.indigo,
            onTap: (value) => context.read<ConsultantAppCubit>().handle(value),
            currentIndex: context.select<ConsultantAppCubit, int>(
                (cubit) => cubit.bottomAppBarIndex),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper),
                label: 'Bài đăng',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: 'Tin nhắn',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Cài đặt',
              ),
            ],
          ),
        );
      }
    );
  }
}
