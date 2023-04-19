import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset('assets/welcome_image.png'),
            Text(
              'Tìm kiếm gia sư',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              'Tạo buổi hẹn với gia sư của bạn',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 24.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/SignIn'),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
