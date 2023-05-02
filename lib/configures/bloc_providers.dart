import 'package:consultant/cubits/analytics/analytics_cubit.dart';
import 'package:consultant/cubits/parent_class/parent_class_cubit.dart';
import 'package:consultant/repositories/lesson_repository.dart';
import 'package:consultant/services/lesson_service.dart';

import '../utils/libs_for_main.dart';

final consultantService = ConsultantServiceIml(
  ConsultantRepository(),
  CommentRepository(),
);

final classService = ClassServiceIml(
  ClassRepository(),
  ClassStudentRepository(),
  ClassExerciseRepository(),
  ClassSubmissionRepository(),
  LessonRepository(),
);

dynamic _providers = [
  BlocProvider(create: (_) => AppCubit()),
  BlocProvider(
    create: (_) => AuthCubit(
      AuthServiceIml(
        FirebaseAuth.instance,
        ConsultantRepository(),
        ParentRepository(),
        StudentRepository(),
      ),
      consultantService,
      ParentServiceIml(ParentRepository(), CommentRepository()),
      StudentServiceIml(StudentRepository()),
    ),
  ),
  BlocProvider(
    create: (_) => HomeCubit(
      ConsultantServiceIml(
        ConsultantRepository(),
        CommentRepository(),
      ),
      ParentServiceIml(
        ParentRepository(),
        CommentRepository(),
      ),
    ),
  ),
  BlocProvider(
    create: (_) => SearchingCubit(consultantService),
  ),
  BlocProvider(
    create: (_) => ChatCubit(
      ChatServiceIml(
        ChatRepository(),
        MessageRepository(),
      ),
      consultantService,
      ParentServiceIml(
        ParentRepository(),
        CommentRepository(),
      ),
    ),
  ),
  BlocProvider(
    create: (_) => MessageCubit(
      MessageServiceIml(MessageRepository()),
      consultantService,
      ParentServiceIml(ParentRepository(), CommentRepository()),
    ),
  ),
  BlocProvider(
    create: (_) => SettingsCubit(
      SettingsServiceIml(SettingsRepository(), ClassRepository()),
      StudentServiceIml(StudentRepository()),
    ),
  ),
  BlocProvider(
    create: (_) => FilterCubit(consultantService),
  ),
  BlocProvider(
    create: (_) => ScheduleCubit(ScheduleServiceIml(ScheduleRepository())),
  ),
  BlocProvider(
    create: (_) => PostCubit(PostServiceIml(PostRepository())),
  ),
  BlocProvider(
    create: (_) => EnrollCubit(
      classService,
      StudentServiceIml(StudentRepository()),
    ),
  ),
  BlocProvider(
    create: (_) => ConsultantHomeCubit(
      consultantService,
      ScheduleServiceIml(ScheduleRepository()),
      classService,
    ),
  ),
  BlocProvider(
    create: (_) => ClassCubit(
      classService,
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
      classService,
      StudentServiceIml(StudentRepository()),
    ),
  ),
  BlocProvider(
    create: (_) => StudentClassCubit(
      classService,
    ),
  ),
  BlocProvider(
    create: (_) => ParentClassCubit(
      classService,
      ParentServiceIml(ParentRepository(), CommentRepository()),
    ),
  ),
  BlocProvider(
    create: (_) => AnalyticsCubit(
      consultantService,
      LessonServiceIml(LessonRepository()),
    ),
  ),
];

dynamic get providers => _providers;
