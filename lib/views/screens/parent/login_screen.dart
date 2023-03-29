import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _pwdController;
  final _key = GlobalKey<FormState>();

  bool invalid = false;
  bool isHidePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _pwdController = TextEditingController();
  }

  @override
  void dispose() {
    _key.currentState?.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.indigo,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.go('/Welcome');
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Không được bỏ trống';
                        }
                        String emailRex =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                        RegExp regExp = RegExp(emailRex);

                        return regExp.hasMatch(value)
                            ? null
                            : 'Email chưa chính xác';
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        prefixIcon: const Icon(Icons.mail),
                        hintText: 'example@gmail.com',
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    TextFormField(
                      controller: _pwdController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Không được bỏ trống';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        hintText: '********',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isHidePassword = !isHidePassword;
                            });
                          },
                          child: Icon(isHidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      obscureText: isHidePassword,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Quên mật khẩu?'),
                      ),
                    ),
                    // const SizedBox(height: 8),
                    Visibility(
                      visible: invalid,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Sai tài khoản hoặc mật khẩu',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        invalid = false;
                        bool isValid = _key.currentState?.validate() ?? false;
                        if (!isValid) return;
                        await context.read<AuthCubit>().signIn(
                              email: _emailController.text,
                              password: _pwdController.text,
                            );
                        if (!mounted) return;
                        if (context.read<AuthCubit>().userCredential == null) {
                          setState(() {
                            invalid = true;
                          });
                        }
                      },
                      child: BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if(state is AuthSignInSuccessed) {
                            context.go('/');
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          return const Text('Đăng nhập');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () => context.go('/Signup'),
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
