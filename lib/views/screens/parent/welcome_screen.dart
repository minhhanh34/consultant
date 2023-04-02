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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     SizedBox(
            //       width: 120.0,
            //       height: 44.0,
            //       child: ElevatedButton(
            //         onPressed: () => context.go('/SignIn'),
            //         child: const Text('Đăng nhập'),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 120.0,
            //       height: 44.0,
            //       child: ElevatedButton(
            //         onPressed: () => context.push('/SignUp'),
            //         child: const Text('Đăng ký'),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextButton(
            //     onPressed: () => context.push(
            //       '/Enroll',
            //     ),
            //     child: const Text('Dành cho học sinh'),
            //   ),
            // ),
            // const Spacer(),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //         padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
            //         shape: MaterialStateProperty.all(const CircleBorder())),
            //     onPressed: () {},
            //     child: const Icon(Icons.arrow_forward),
            //   ),
            // ),
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
