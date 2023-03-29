import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _pwdController;
  late TextEditingController _confirmPwdController;
  final _key = GlobalKey<FormState>();

  bool invalid = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _pwdController = TextEditingController();
    _confirmPwdController = TextEditingController();
  }

  @override
  void dispose() {
    _key.currentState?.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.go('/SignIn'),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        prefixIcon: const Icon(Icons.person_outline),
                        hintText: 'example@gmail.com',
                      ),
                    ),
                    // const SizedBox(
                    //   height: 16.0,
                    // ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(16.0),
                    //     ),
                    //     prefixIcon: const Icon(Icons.email_outlined),
                    //     hintText: 'Email address',
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 16.0,
                    // ),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(16.0),
                    //     ),
                    //     prefixIcon: const Icon(Icons.phone_outlined),
                    //     hintText: 'Phone numbers',
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _pwdController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Không được bỏ trống';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        prefixIcon: const Icon(Icons.lock_outlined),
                        hintText: '********',
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _confirmPwdController,
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
                        prefixIcon: const Icon(Icons.confirmation_num_outlined),
                        hintText: '********',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: invalid,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Thông tin chưa chính xác',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        invalid = false;
                        bool isValid = _key.currentState?.validate() ?? false;
                        if (!isValid) return;
                        if (_pwdController.text != _confirmPwdController.text) {
                          setState(() {
                            invalid = true;
                          });
                          return;
                        }
                        context.read<AuthCubit>().createUser(
                              email: _emailController.text,
                              password: _pwdController.text,
                            );
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 48.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      child: BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSignUpSuccessed) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Đăng ký thành công'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => context.go('/SignIn'),
                                      child: const Text('Ok'),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          if (state is AuthSignUpSuccessed) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.done),
                                Text('Đăng ký thành công')
                              ],
                            );
                          }
                          return const Text('Đăng ký');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
