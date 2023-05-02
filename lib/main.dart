import 'package:consultant/configures/bloc_providers.dart';
import 'package:consultant/configures/router.dart';
import 'package:flutter/material.dart';
import './utils/libs_for_main.dart';

void main() async {
  final flutterBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final data = await initialize(flutterBinding);
  final String initialLocation = getInitialLocation(data);
  runApp(ConsultantApp(initialLocation: initialLocation));
}

Future<Map<String, String>> initialize(WidgetsBinding flutterBinding) async {
  FlutterNativeSplash.preserve(widgetsBinding: flutterBinding);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  return await secureStorage.readAll();
}

class ConsultantApp extends StatelessWidget {
  const ConsultantApp({super.key, required this.initialLocation});
  final String initialLocation;
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp.router(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        routerConfig: GoRouter(
          initialLocation: initialLocation,
          routes: routes,
        ),
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
  if (data['infoUpdated'] == 'true') {
    AuthCubit.setInfoUpdated = true;
  } else {
    AuthCubit.setInfoUpdated = false;
  }

  if (data['userType']?.toLowerCase() == 'consultant') return '/ConsultantHome';
  if (data['userType']?.toLowerCase() == 'parent') return '/';
  if (data['userType']?.toLowerCase() == 'student') return '/Student';
  return '/Welcome';
}
