import 'package:consultant/cubits/app/app_cubit.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/firebase_options.dart';
import 'package:consultant/models/consultant.dart';
import 'package:consultant/repositories/consultant_repository.dart';
import 'package:consultant/services/consultant.dart';
import 'package:consultant/views/screens/consultant_detail_screen.dart';
import 'package:consultant/views/screens/home_screen.dart';
import 'package:consultant/views/screens/login_screen.dart';
import 'package:consultant/views/screens/signup_screen.dart';
import 'package:consultant/views/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

void main() async {
  final flutterBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: flutterBinding);
  // final consultant = Consultant(
  //   name: 'Bùi Thanh Thúy',
  //   birthDay: DateTime(1995, 12, 1),
  //   address: 'Cần Thơ',
  //   subjects: const ['Vật Lý', 'Hóa Học'],
  // );
  // final consultantRepo = ConsultantRepository();
  // consultantRepo.create(consultant);
  // final student = Student(
  //   name: 'Minh Hanh',
  //   address: 'An Giang',
  //   birthDay: DateTime(2001, 04, 30),
  //   grade: 16,
  // );
  // final studentRepo = StudentRepository();
  // await studentRepo.create(student);
  // await consultantRepo.create(consultant);
  // final list = await studentRepo.list();
  // for(var item in list) {
  //   print(item.toJson());
  // }
  // const parent = Parent(name: 'Minh Hanh', phone: '0394567429', email: 'hanhb1909911');
  // final parentRepo = ParentRepository();
  // parentRepo.create(parent);
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
      builder: (context, state) => ConsultantDetailScreen(
        consultant: state.extra! as Consultant,
      ),
    ),
    GoRoute(
      path: '/Welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/Login',
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      path: '/Signup',
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);

class ConsultantApp extends StatelessWidget {
  const ConsultantApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(
          create: (_) => HomeCubit(
            consultantService: ConsultantService(
              ConsultantRepository(),
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          // fontFamily: 'Poppins',
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Material App',
      ),
    );
  }
}
