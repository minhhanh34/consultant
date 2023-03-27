import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _pwdController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _pwdController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Text(
                  'Đăng nhập',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: decoration(
                      hintText: 'example@gmail.com',
                      prefixIcon: Icons.mail,
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _pwdController,
                    decoration: decoration(
                      hintText: '********',
                      prefixIcon: Icons.lock,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(16.0),
                        ),
                        shape: MaterialStateProperty.all(const CircleBorder()),
                      ),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {},
                  child: const Text('Quên mật khẩu?'),
                ),
                TextButton(
                  onPressed: () => context.push('/SignUp'),
                  child: const Text('Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // InkWell(
  //                   child: Container(
  //                     padding: EdgeInsets.all(16),
  //                     decoration: const BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: Colors.indigo,
  //                     ),
  //                     child: const Icon(Icons.arrow_forward),
  //                   ),
  //                 ),

  InputDecoration decoration({
    String? hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
    );
  }
}
