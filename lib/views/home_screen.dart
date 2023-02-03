import 'package:consultant/models/consultant.dart';
import 'package:consultant/views/consultants_overview.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ConsultantOverview(
        [
          Consultant(
              name: 'Hanh',
              birthDay: DateTime(2001, 04, 30),
              address: 'An Giang')
        ],
      ),
    );
  }
}
