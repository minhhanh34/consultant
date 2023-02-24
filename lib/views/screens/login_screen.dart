import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isHidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text('SKIP'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/welcome_image.png'),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Enter Username',
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Enter password',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isHidePassword = !isHidePassword;
                            });
                          },
                          child: const Icon(Icons.visibility_off),
                        ),
                      ),
                      obscureText: isHidePassword,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 48.0),
                        ),
                      ),
                      onPressed: () => context.go('/'),
                      child: const Text('Log in'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () => context.go('/Signup'),
                child: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
