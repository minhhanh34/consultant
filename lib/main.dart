import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/cubits/app/app_cubit.dart';
import 'package:consultant/cubits/chat/chat_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_app/consultant_app_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_settings/consultant_settings_cubit.dart';
import 'package:consultant/cubits/filter/filter_cubit.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/cubits/posts/post_cubit.dart';
import 'package:consultant/cubits/schedules/schedules_cubit.dart';
import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:consultant/cubits/settings/settings_cubit.dart';
import 'package:consultant/firebase_options.dart';
import 'package:consultant/repositories/class_exercise_subcollection_repository.dart';
import 'package:consultant/repositories/class_repository.dart';
import 'package:consultant/repositories/class_student_subcollection_repository.dart';
import 'package:consultant/repositories/message_repository.dart';
import 'package:consultant/repositories/comment_repository.dart';
import 'package:consultant/repositories/consultant_repository.dart';
import 'package:consultant/repositories/chat_repository.dart';
import 'package:consultant/repositories/post_repository.dart';
import 'package:consultant/repositories/schedule_repository.dart';
import 'package:consultant/repositories/settings_repository.dart';
import 'package:consultant/services/chat_service.dart';
import 'package:consultant/services/class_service.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/message_service.dart';
import 'package:consultant/services/post_service.dart';
import 'package:consultant/services/schedule_service.dart';
import 'package:consultant/services/settings_service.dart';
import 'package:consultant/views/screens/consultant/class_detail.dart';
import 'package:consultant/views/screens/consultant/consultant_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import 'models/class_model.dart';
import 'models/comment_model.dart';
import 'models/consultant_model.dart';
import 'models/parent_model.dart';
import 'views/screens/consultant/camera_screen.dart';
import 'views/screens/parent/all_comment_screen.dart';
import 'views/screens/parent/chat_screen.dart';
import 'views/screens/parent/consultant_detail_screen.dart';
import 'views/screens/parent/consultant_filtered_screen.dart';
import 'views/screens/parent/consultants_screen.dart';
import 'views/screens/parent/home_screen.dart';
import 'views/screens/parent/login_screen.dart';
import 'views/screens/parent/map_screen.dart';
import 'views/screens/parent/parent_info_screen.dart';
import 'views/screens/parent/signup_screen.dart';
import 'views/screens/parent/welcome_screen.dart';

late final FirebaseApp _app;
late final FirebaseAuth _auth;
late final List<CameraDescription> _cameras;

FirebaseApp get app => _app;
List<CameraDescription> get cameras => _cameras;

void main() async {
  final flutterBinding = WidgetsFlutterBinding.ensureInitialized();
  _app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: flutterBinding);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  _auth = FirebaseAuth.instanceFor(app: _app);

  String email = 'hanh@gmail.com';
  String password = 'hanh123';
  await _auth.signInWithEmailAndPassword(email: email, password: password);

  // final storage = FirebaseStorageService();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  // await storage.ref.child('exercises').child('abc').putString('ad');
  runApp(const ConsultantApp());
}

class ConsultantApp extends StatelessWidget {
  const ConsultantApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final consultantService = ConsultantService(
      ConsultantRepository(),
      CommentRepository(),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(
          create: (_) => HomeCubit(consultantService),
        ),
        BlocProvider(
          create: (_) => SearchingCubit(consultantService),
        ),
        BlocProvider(
          create: (_) =>
              ChatCubit(ChatService(ChatRepository()), consultantService),
        ),
        BlocProvider(
          create: (_) => MessageCubit(MessageService(MessageRepository())),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(SettingsService(SettingsRepository())),
        ),
        BlocProvider(
          create: (_) => FilterCubit(consultantService),
        ),
        BlocProvider(
          create: (_) => ScheduleCubit(ScheduleService(ScheduleRepository())),
        ),
        BlocProvider(
          create: (_) => PostCubit(PostService(PostRepository())),
        ),
        BlocProvider(
          create: (_) => ConsultantHomeCubit(
            ScheduleService(ScheduleRepository()),
            ClassService(
              ClassRepository(),
              ClassStudentRepository(),
              ClassExerciseRepository(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ClassCubit(
            ClassService(
              ClassRepository(),
              ClassStudentRepository(),
              ClassExerciseRepository(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ConsultantAppCubit(),
        ),
        BlocProvider(
          create: (_) => ConsultantSettingsCubit(consultantService),
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

final _router = GoRouter(
  initialLocation: '/ConsultantHome',
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
    GoRoute(
      path: '/Map',
      builder: (context, state) => MapScreen(geoPoint: state.extra as GeoPoint),
    ),
    GoRoute(
      path: '/ChatRoom',
      // builder: (context, state) => ChatScreen(
      //   partner: (state.extra as Map)['partner'],
      //   room: (state.extra as Map)['room'],
      // ),
      pageBuilder: (context, state) => CupertinoPage(
        child: ChatScreen(
          partnerId: (state.extra as Map)['partnerId'],
          room: (state.extra as Map)['room'],
        ),
      ),
    ),
    GoRoute(
      path: '/Comments',
      builder: (context, state) =>
          CommentsScreen(comments: state.extra as List<Comment>),
    ),
    GoRoute(
      path: '/Info',
      builder: (context, state) =>
          ParentInfoScreen(parent: state.extra as Parent),
    ),
    GoRoute(
      path: '/ConsultantsFiltered',
      builder: (context, state) => ConsultantsFilteredScreen(
        filtered: state.extra as List<String>,
      ),
    ),
    GoRoute(
      path: '/ConsultantHome',
      builder: (context, state) => const ConsultantHomeScreen(),
    ),
    GoRoute(
      path: '/ClassDetail',
      builder: (context, state) => ClassDetail(classRoom: state.extra as Class),
    ),
    GoRoute(
      path: '/Camera',
      builder: (context, state) => CameraScreen(
        cameras: state.extra as List<CameraDescription>,
      ),
    ),
  ],
);
