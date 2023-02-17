import 'package:consultant/views/components/home_container.dart';
import 'package:consultant/views/components/messages_container.dart';
import 'package:consultant/views/components/schedule_container.dart';
import 'package:consultant/views/components/settings_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: Builder(
        builder: (context) {
          if (bottomNavigationIndex == 0) return const HomeContainer();
          if (bottomNavigationIndex == 1) return const MessagesContainer();
          if (bottomNavigationIndex == 2) return const ScheduleContainer();
          if (bottomNavigationIndex == 3) return const SettingsContainer();
          return const SizedBox();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            bottomNavigationIndex = value;
          });
        },
        currentIndex: bottomNavigationIndex,
        showUnselectedLabels: true,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_fill),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
