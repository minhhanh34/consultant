import 'package:consultant/firebase_options.dart';
import 'package:consultant/views/consultant_detail_screen.dart';
import 'package:consultant/views/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    GoRoute(
      path: '/Detail',
      builder: (context, state) => const ConsultantDetailScreen(),
    ),
  ],
);

class ConsultantApp extends StatelessWidget {
  const ConsultantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
    );
  }
}
