import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/cubits/app/app_cubit.dart';
import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/chat/chat_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_app/consultant_app_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_settings/consultant_settings_cubit.dart';
import 'package:consultant/cubits/enroll/enroll_cubit.dart';
import 'package:consultant/cubits/filter/filter_cubit.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/cubits/posts/post_cubit.dart';
import 'package:consultant/cubits/schedules/schedules_cubit.dart';
import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:consultant/cubits/settings/settings_cubit.dart';
import 'package:consultant/cubits/student_class/student_class_cubit.dart';
import 'package:consultant/cubits/student_home/student_home_cubit.dart';
import 'package:consultant/firebase_options.dart';
import 'package:consultant/models/submission_model.dart';
import 'package:consultant/repositories/class_exercise_subcollection_repository.dart';
import 'package:consultant/repositories/class_repository.dart';
import 'package:consultant/repositories/class_student_subcollection_repository.dart';
import 'package:consultant/repositories/class_submission_subcollection_repository.dart';
import 'package:consultant/repositories/message_repository.dart';
import 'package:consultant/repositories/comment_repository.dart';
import 'package:consultant/repositories/consultant_repository.dart';
import 'package:consultant/repositories/chat_repository.dart';
import 'package:consultant/repositories/parent_repository.dart';
import 'package:consultant/repositories/post_repository.dart';
import 'package:consultant/repositories/schedule_repository.dart';
import 'package:consultant/repositories/settings_repository.dart';
import 'package:consultant/repositories/student_repository.dart';
import 'package:consultant/services/auth_service.dart';
import 'package:consultant/services/chat_service.dart';
import 'package:consultant/services/class_service.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/message_service.dart';
import 'package:consultant/services/parent_service.dart';
import 'package:consultant/services/post_service.dart';
import 'package:consultant/services/schedule_service.dart';
import 'package:consultant/services/settings_service.dart';
import 'package:consultant/services/student_service.dart';
import 'package:consultant/views/screens/consultant/class_detail.dart';
import 'package:consultant/views/screens/consultant/consultant_class_submissions_screen.dart';
import 'package:consultant/views/screens/consultant/consultant_home_screen.dart';
import 'package:consultant/views/screens/student/enroll_screen.dart';
import 'package:consultant/views/screens/student/student_class_overview.dart';
import 'package:consultant/views/screens/student/student_class_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'models/class_model.dart';
import 'models/comment_model.dart';
import 'models/consultant_model.dart';
import 'models/parent_model.dart';
import 'models/student_model.dart';
import 'views/screens/consultant/camera_screen.dart';
import 'views/screens/consultant/consultant_class_students_screen.dart';
import 'views/screens/consultant/consultant_update_screen.dart';
import 'views/screens/parent/all_comment_screen.dart';
import 'views/screens/parent/chat_screen.dart';
import 'views/screens/parent/consultant_detail_screen.dart';
import 'views/screens/parent/consultant_filtered_screen.dart';
import 'views/screens/parent/consultants_screen.dart';
import 'views/screens/parent/home_screen.dart';
import 'views/screens/parent/parent_update_screen.dart';
import 'views/screens/parent/signin_screen.dart';
import 'views/screens/parent/map_screen.dart';
import 'views/screens/parent/parent_info_screen.dart';
import 'views/screens/parent/signup_screen.dart';
import 'views/screens/parent/welcome_screen.dart';

late final FirebaseApp _app;
late final FirebaseAuth _auth;
late final List<CameraDescription> _cameras;
late FlutterSecureStorage _secureStorage;
FlutterSecureStorage get secureStorage => _secureStorage;
FirebaseApp get app => _app;
List<CameraDescription> get cameras => _cameras;
late final String _initialLocation;

void main() async {
  final flutterBinding = WidgetsFlutterBinding.ensureInitialized();

  _app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final data = await initialize(flutterBinding);

  _initialLocation = getInitialLocation(data);

  runApp(const ConsultantApp());
}

Future<Map<String, String>> initialize(WidgetsBinding flutterBinding) async {
  FlutterNativeSplash.preserve(widgetsBinding: flutterBinding);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  _auth = FirebaseAuth.instanceFor(app: _app);
  _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  return await _secureStorage.readAll();
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
          create: (_) => AuthCubit(
            AuthService(
              _auth,
              ConsultantRepository(),
              ParentRepository(),
              StudentRepository(),
            ),
            ConsultantService(ConsultantRepository(), CommentRepository()),
            ParentService(ParentRepository()),
            StudentService(StudentRepository()),
          ),
        ),
        BlocProvider(
          create: (_) => HomeCubit(
            consultantService,
            ParentService(
              ParentRepository(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => SearchingCubit(consultantService),
        ),
        BlocProvider(
          create: (_) => ChatCubit(
              ChatService(
                ChatRepository(),
                MessageRepository(),
              ),
              consultantService),
        ),
        BlocProvider(
          create: (_) => MessageCubit(
            MessageService(MessageRepository()),
            consultantService,
            ParentService(ParentRepository()),
          ),
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
          create: (_) => EnrollCubit(
              ClassService(
                ClassRepository(),
                ClassStudentRepository(),
                ClassExerciseRepository(),
                ClassSubmissionRepository(),
              ),
              StudentService(StudentRepository())),
        ),
        BlocProvider(
          create: (_) => ConsultantHomeCubit(
            consultantService,
            ScheduleService(ScheduleRepository()),
            ClassService(
              ClassRepository(),
              ClassStudentRepository(),
              ClassExerciseRepository(),
              ClassSubmissionRepository(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ClassCubit(
            ClassService(
              ClassRepository(),
              ClassStudentRepository(),
              ClassExerciseRepository(),
              ClassSubmissionRepository(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ConsultantAppCubit(),
        ),
        BlocProvider(
          create: (_) => ConsultantSettingsCubit(consultantService),
        ),
        BlocProvider(
          create: (_) => StudentHomeCubit(
            ClassService(
              ClassRepository(),
              ClassStudentRepository(),
              ClassExerciseRepository(),
              ClassSubmissionRepository(),
            ),
            StudentService(StudentRepository()),
          ),
        ),
        BlocProvider(
          create: (_) => StudentClassCubit(
            ClassService(
              ClassRepository(),
              ClassStudentRepository(),
              ClassExerciseRepository(),
              ClassSubmissionRepository(),
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Material App',
      ),
    );
  }
}

String getInitialLocation(Map<String, String> data) {
  if (data['userType'] == null || data['uid'] == null || data['id'] == null) {
    return '/Welcome';
  }
  AuthCubit.setCurrentUserId = data['id']!;
  AuthCubit.setUid = data['uid']!;
  AuthCubit.setUserType = data['userType']!;
  if (data['userType']?.toLowerCase() == 'consultant') return '/ConsultantHome';
  if (data['userType']?.toLowerCase() == 'parent') return '/';
  if (data['userType']?.toLowerCase() == 'Student') return '/Student';
  return '/Welcome';
}

final _router = GoRouter(
  initialLocation: _initialLocation,
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
      path: '/SignIn',
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      path: '/SignUp',
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
    GoRoute(
      path: '/Enroll',
      builder: (context, state) => EnrollScreen(
        student: state.extra as Student,
      ),
    ),
    GoRoute(
      path: '/StudentClass',
      builder: (context, state) => StudentClassScreen(
        id: (state.extra as Map<String, dynamic>)['classId'] as String,
        studentId: (state.extra as Map<String, dynamic>)['studentId'] as String,
      ),
    ),
    GoRoute(
      path: '/Student',
      builder: (context, state) => const StudentClassHome(),
    ),
    GoRoute(
      path: '/ConsultantClassSubmissions',
      builder: (context, state) => ConsultantClassSubmissionsScreen(
        submissions: (state.extra as Map)['submissions'] as List<Submission>,
        classId: (state.extra as Map)['classId'] as String,
      ),
    ),
    GoRoute(
      path: '/ConsultantClassStudents',
      builder: (context, state) => ConsultantClassStudentsScreen(
        students: (state.extra as Map)['students'],
        classRoom: (state.extra as Map)['classRoom'],
      ),
    ),
    GoRoute(
      path: '/ConsultantUpdate',
      builder: (context, state) => const ConsultantUpdateScreen(),
    ),
    GoRoute(
      path: '/ParentUpdate',
      builder: (context, state) =>
          ParentUpdateScreen(parent: state.extra as Parent?),
    ),
  ],
);
