import '../screens/parent/parent_class_screen.dart';
import '../utils/libs_for_main.dart';
import '../screens/parent/children_screen.dart';

final dynamic _routes = <RouteBase>[
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
  // GoRoute(
  //   path: '/Camera',
  //   builder: (context, state) => CameraScreen(
  //     cameras: state.extra as List<CameraDescription>,
  //   ),
  // ),
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
    builder: (context, state) => ConsultantUpdateScreen(
      consultant: state.extra as Consultant?,
    ),
  ),
  GoRoute(
    path: '/ParentUpdate',
    builder: (context, state) =>
        ParentUpdateScreen(parent: state.extra as Parent?),
  ),
  GoRoute(
    path: '/RelationShip',
    builder: (context, state) =>
        ChildrensScreen(children: state.extra as List<Student>),
  ),
  GoRoute(
    path: '/ParentClass',
    builder: (context, state) => ParentClassScreen(
      classId: state.extra as String,
    ),
  ),
];

dynamic get routes => _routes;
