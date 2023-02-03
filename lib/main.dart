import 'package:consultant/firebase_options.dart';
import 'package:consultant/models/consultant.dart';
import 'package:consultant/repositories/consultant_repository.dart';
import 'package:consultant/repositories/student_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/student.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final consultant = Consultant(
  //   name: 'Minh Hanh',
  //   birthDay: DateTime(2001, 04, 30),
  //   address: 'An Giang',
  // );
  // final student = Student(
  //   name: 'Minh Hanh',
  //   address: 'An Giang',
  //   birthDay: DateTime(2001, 04, 30),
  //   grade: 16,
  // );
  // final consultantRepo = ConsultantRepository();
  // final studentRepo = StudentRepository();
  // // await studentRepo.create(student);
  // // await consultantRepo.create(consultant);
  // final list = await studentRepo.list();
  // for(var item in list) {
  //   print(item.toJson());
  // }
  runApp(const ConsultantApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

class ConsultantApp extends StatelessWidget {
  const ConsultantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
    );
  }
}
