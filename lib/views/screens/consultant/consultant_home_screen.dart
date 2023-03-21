import 'package:consultant/cubits/consultant_cubits/consultant_app/consultant_app_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_app/consultant_app_state.dart';
import 'package:consultant/views/screens/consultant/consultant_home_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'consultant_post_container.dart';
import 'consultant_settings.dart';

class ConsultantHomeScreen extends StatefulWidget {
  const ConsultantHomeScreen({super.key});

  @override
  State<ConsultantHomeScreen> createState() => _ConsultantHomeScreenState();
}

class _ConsultantHomeScreenState extends State<ConsultantHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ConsultantAppCubit, ConsultantAppState>(
        builder: (context, state) {
          if (state is ConsultantHome) {
            return const ConsultantHomeContainer();
          }
          if (state is ConsultantPost) {
            return const ConsultantPostContainer();
          }
          if (state is ConsultantSettings) {
            return const ConsultantSettingsContainer();
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
