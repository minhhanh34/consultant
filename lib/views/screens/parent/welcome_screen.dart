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
        actions: [
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text('SKIP'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset('assets/welcome_image.png'),
            Text(
              'Teacher Appointment',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              'Apoint yourr teacher',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 48.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 120.0,
                  height: 44.0,
                  child: ElevatedButton(
                    onPressed: () => context.go('/Login'),
                    child: const Text('Log in'),
                  ),
                ),
                SizedBox(
                  width: 120.0,
                  height: 44.0,
                  child: ElevatedButton(
                    onPressed: () => context.go('/Signup'),
                    child: const Text('Sign up'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
