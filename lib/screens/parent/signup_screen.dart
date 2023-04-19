import 'package:consultant/cubits/auth/auth_state.dart';
import 'package:consultant/utils/libs_for_main.dart';
import 'package:flutter/material.dart';

import '../../constants/user_types.dart';

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
  var userType = UserType.parent;
  String parentId = '';

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
        leading: IconButton(
          onPressed: () => context.go('/Welcome'),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
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
                    DropdownButtonFormField<UserType>(
                      value: userType,
                      items: const [
                        DropdownMenuItem(
                          value: UserType.consultant,
                          child: Text('Gia sư'),
                        ),
                        DropdownMenuItem(
                          value: UserType.parent,
                          child: Text('Phụ huynh'),
                        ),
                        DropdownMenuItem(
                          value: UserType.student,
                          child: Text('Học sinh'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          userType = value ?? userType;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: userType == UserType.student,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          initialValue: parentId,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Không được bỏ trống';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            if (newValue != null && newValue.isNotEmpty) {
                              parentId = newValue;
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.key),
                            hintText: 'Mã số phụ huynh của bạn',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthMessage) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        invalid = false;
                        bool isValid = _key.currentState?.validate() ?? false;
                        if (!isValid) return;
                        _key.currentState?.save();
                        if (_pwdController.text != _confirmPwdController.text) {
                          setState(() {
                            invalid = true;
                          });
                          return;
                        }
                        final authCubit = context.read<AuthCubit>();
                        authCubit.createUser(
                          userType: userType,
                          email: _emailController.text,
                          password: _pwdController.text,
                          parentId: parentId,
                        );
                        if (authCubit.state.runtimeType != AuthMessage) {
                          _key.currentState?.reset();
                        }
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
                    const SizedBox(height: 16.0),
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
