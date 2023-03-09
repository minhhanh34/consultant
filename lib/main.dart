import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/cubits/app/app_cubit.dart';
import 'package:consultant/cubits/chat_rooms/chat_room_cubit.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:consultant/cubits/settings/settings_cubit.dart';
import 'package:consultant/firebase_options.dart';
import 'package:consultant/models/address.dart';
import 'package:consultant/models/comment.dart';
import 'package:consultant/models/consultant.dart';
import 'package:consultant/models/parent.dart';
import 'package:consultant/repositories/chat_room_repository.dart';
import 'package:consultant/repositories/comment_repository.dart';
import 'package:consultant/repositories/consultant_repository.dart';
import 'package:consultant/repositories/message_repository.dart';
import 'package:consultant/repositories/parent_repository.dart';
import 'package:consultant/repositories/settings_repository.dart';
import 'package:consultant/services/chat_room_service.dart';
import 'package:consultant/services/consultant.dart';
import 'package:consultant/services/message_service.dart';
import 'package:consultant/services/settings_service.dart';
import 'package:consultant/views/screens/all_comment_screen.dart';
import 'package:consultant/views/screens/chat_screen.dart';
import 'package:consultant/views/screens/consultant_detail_screen.dart';
import 'package:consultant/views/screens/consultants_screen.dart';
import 'package:consultant/views/screens/home_screen.dart';
import 'package:consultant/views/screens/login_screen.dart';
import 'package:consultant/views/screens/map_screen.dart';
import 'package:consultant/views/screens/parent_info_screen.dart';
import 'package:consultant/views/screens/signup_screen.dart';
import 'package:consultant/views/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

void main() async {
  final flutterBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: flutterBinding);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  const parent = Parent(
    name: 'Nguyễn Văn Chu',
    phone: '0394122132',
    email: 'nvchu123@gmail.com',
    address: Address(
      city: 'Long An',
      district: 'Cay Lậy',
      geoPoint: GeoPoint(10.4044749, 106.0325383),
    ),
  );

  final repo = ParentRepository();
  // await repo.create(parent);

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
    GoRoute(
      path: '/Map',
      builder: (context, state) => MapScreen(geoPoint: state.extra as GeoPoint),
    ),
    GoRoute(
      path: '/ChatRoom',
      pageBuilder: (context, state) => CupertinoPage(
        child: ChatScreen(
          partner: (state.extra as Map)['partner'],
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
      builder: (context, state) => ParentInfoScreen(parent: state.extra as Parent),
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
          create: (_) => ChatRoomCubit(ChatRoomService(ChatRoomRepository())),
        ),
        BlocProvider(
          create: (_) => MessageCubit(MessageService(MessageRepository())),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(SettingsService(SettingsRepository())),
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
