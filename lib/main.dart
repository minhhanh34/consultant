import 'package:consultant/configures/bloc_providers.dart';
import 'package:consultant/configures/router.dart';
import 'package:flutter/material.dart';
import './utils/libs_for_main.dart';

late final FirebaseApp _app;
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
    return MultiBlocProvider(
      providers: providers,
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
  if (data['userType']?.toLowerCase() == 'student') return '/Student';
  return '/Welcome';
}

final _router = GoRouter(
  initialLocation: _initialLocation,
  routes: routes,
);
