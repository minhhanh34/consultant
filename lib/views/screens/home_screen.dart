import 'package:consultant/cubits/app/app_state.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/views/components/messages_container.dart';
import 'package:consultant/views/components/schedule_container.dart';
import 'package:consultant/views/components/settings_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/app/app_cubit.dart';
import '../components/home_container.dart';
import '../components/searching_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomNavigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            if (state is Home) {
              context.read<HomeCubit>().getConsultants();
              return const HomeContainer();
            }
            if (state is Searching) return const SearchingContainer();
            if (state is Messages) return const MessagesContainer();
            if (state is Schedules) return const ScheduleContainer();
            if (state is Settings) return const SettingsContainer();
            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => context.read<AppCubit>().handle(value),
        currentIndex: context.select<AppCubit, int>(
          (cubit) => cubit.bottomAppBarIndex,
        ),
        showUnselectedLabels: true,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              label: 'Tin nhắn',
              activeIcon: Icon(CupertinoIcons.chat_bubble_fill)),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Lịch hẹn',
              activeIcon: Icon(Icons.calendar_month_sharp)),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Cài đặt',
            activeIcon: Icon(Icons.settings_rounded),
          ),
        ],
      ),
    );
  }
}
