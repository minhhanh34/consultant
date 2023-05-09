import 'package:consultant/screens/student/drawer.dart';
import 'package:consultant/screens/student/update_information.dart';

import '../screens/consultant/analytics_screen.dart';
import '../screens/parent/parent_class_screen.dart';
import '../screens/student/student_settings_screen.dart';
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
  GoRoute(
    path: '/StudentUpdate',
    builder: (context, state) {
      Student student = (state.extra as Map)['student'];
      bool isFirstUpdate = (state.extra as Map)['isFirstUpdate'];
      return StudentUpdateInformation(
        student: student,
        isFirstUpdate: isFirstUpdate,
      );
    },
  ),
  GoRoute(
    path: '/StudentSettings',
    builder: (context, state) => StudentSettingsScreen(
      student: (state.extra as Map)['student'] as Student,
      drawer: (state.extra as Map)['drawer'] as StudentDrawer,
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
      parentMode: (state.extra as Map)['parentMode'] as bool?,
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
    builder: (context, state) {
      final Consultant? consultant =
          (state.extra as Map<String, dynamic>)['consultant'];
      final bool? isFirstUpdate =
          (state.extra as Map<String, dynamic>)['isFirstUpdate'];
      return ConsultantUpdateScreen(
        consultant: consultant,
        isFirstUpdate: isFirstUpdate ?? false,
      );
    },
  ),
  GoRoute(
      path: '/ParentUpdate',
      builder: (context, state) {
        Parent? parent = (state.extra as Map)['parent'];
        bool isFirstUpdate = (state.extra as Map)['isFirstUpdate'];
        return ParentUpdateScreen(
          parent: parent,
          isFirstUpdate: isFirstUpdate,
        );
      }),
  GoRoute(
    path: '/RelationShip',
    builder: (context, state) =>
        ChildrensScreen(children: state.extra as List<Student>),
  ),
  GoRoute(
    path: '/ParentClass',
    builder: (context, state) => ParentClassScreen(
      classroom: state.extra as Class,
    ),
  ),
  GoRoute(
    path: '/ConsultantAnalytics',
    builder: (context, state) => ConsultantAnalyticsScreen(
      consultant: state.extra as Consultant,
    ),
  ),
];

dynamic get routes => _routes;
