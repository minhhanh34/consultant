import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConsultantsScreen extends StatelessWidget {
  const ConsultantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Consultants',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
