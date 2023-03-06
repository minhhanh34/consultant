import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/cubits/app/app_cubit.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:consultant/firebase_options.dart';
import 'package:consultant/models/address.dart';
import 'package:consultant/models/consultant.dart';
import 'package:consultant/models/schedule.dart';
import 'package:consultant/models/subject.dart';
import 'package:consultant/repositories/consultant_repository.dart';
import 'package:consultant/repositories/schedule_repository.dart';
import 'package:consultant/services/consultant.dart';
import 'package:consultant/views/screens/consultant_detail_screen.dart';
import 'package:consultant/views/screens/consultants_screen.dart';
import 'package:consultant/views/screens/home_screen.dart';
import 'package:consultant/views/screens/login_screen.dart';
import 'package:consultant/views/screens/signup_screen.dart';
import 'package:consultant/views/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

void main() async {
  final flutterBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: flutterBinding);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final schedule = Schedule(
    consultantName: 'Nguyễn Văn Tèo',
    subjectName: 'Hóa học',
    dateTime: DateTime(2023, 3, 10, 8),
    state: ScheduleStates.upComing,
  );
  
  final scheduleRepo = ScheduleRepository();
  // final list = await scheduleRepo.list();
  // print(list[0].state);
  // scheduleRepo.create(schedule);
  
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
    GoRoute(
      path: '/Consultants',
      builder: (context, state) => const ConsultantsScreen(),
    ),
  ],
);

class ConsultantApp extends StatelessWidget {
  const ConsultantApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final consultantService = ConsultantService(
      ConsultantRepository(),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(
          create: (_) => HomeCubit(
            consultantService: consultantService,
          ),
        ),
        BlocProvider(
          create: (_) => SearchingCubit(service: consultantService),
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
