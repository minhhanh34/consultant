// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:go_router/go_router.dart';

// import '../models/comment_model.dart';
// import '../models/consultant_model.dart';
// import '../models/parent_model.dart';
// import '../views/screens/parent/all_comment_screen.dart';
// import '../views/screens/parent/chat_screen.dart';
// import '../views/screens/parent/consultant_detail_screen.dart';
// import '../views/screens/parent/consultant_filtered_screen.dart';
// import '../views/screens/parent/consultants_screen.dart';
// import '../views/screens/parent/home_screen.dart';
// import '../views/screens/parent/login_screen.dart';
// import '../views/screens/parent/map_screen.dart';
// import '../views/screens/parent/parent_info_screen.dart';
// import '../views/screens/parent/signup_screen.dart';
// import '../views/screens/parent/welcome_screen.dart';


// final _router = GoRouter(
//   initialLocation: '/',
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const HomeScreen(),
//     ),
//     GoRoute(
//       path: '/Detail',
//       builder: (context, state) => ConsultantDetailScreen(
//         consultant: state.extra! as Consultant,
//       ),
//     ),
//     GoRoute(
//       path: '/Welcome',
//       builder: (context, state) => const WelcomeScreen(),
//     ),
//     GoRoute(
//       path: '/Login',
//       builder: (context, state) => const LogInScreen(),
//     ),
//     GoRoute(
//       path: '/Signup',
//       builder: (context, state) => const SignUpScreen(),
//     ),
//     GoRoute(
//       path: '/Consultants',
//       builder: (context, state) => const ConsultantsScreen(),
//     ),
//     GoRoute(
//       path: '/Map',
//       builder: (context, state) => MapScreen(geoPoint: state.extra as GeoPoint),
//     ),
//     GoRoute(
//       path: '/ChatRoom',
//       pageBuilder: (context, state) => CupertinoPage(
//         child: ChatScreen(
//           partnerId: (state.extra as Map)['partnerId'],
//           room: (state.extra as Map)['room'],
//         ),
//       ),
//     ),
//     GoRoute(
//       path: '/Comments',
//       builder: (context, state) =>
//           CommentsScreen(comments: state.extra as List<Comment>),
//     ),
//     GoRoute(
//       path: '/Info',
//       builder: (context, state) =>
//           ParentInfoScreen(parent: state.extra as Parent),
//     ),
//     GoRoute(
//       path: '/ConsultantsFiltered',
//       builder: (context, state) => ConsultantsFilteredScreen(
//         filtered: state.extra as List<String>,
//       ),
//     ),
//   ],
// );

// GoRouter get router => _router;
