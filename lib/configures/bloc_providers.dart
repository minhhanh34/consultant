import '../utils/libs_for_main.dart';

final consultantService = ConsultantService(
  ConsultantRepository(),
  CommentRepository(),
);

dynamic _providers = [
  BlocProvider(create: (_) => AppCubit()),
  BlocProvider(
    create: (_) => AuthCubit(
      AuthService(
        FirebaseAuth.instance,
        ConsultantRepository(),
        ParentRepository(),
        StudentRepository(),
      ),
      consultantService,
      ParentService(ParentRepository()),
      StudentService(StudentRepository()),
    ),
  ),
  BlocProvider(
    create: (_) => HomeCubit(
      ConsultantService(
        ConsultantRepository(),
        CommentRepository(),
      ),
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
      consultantService,
      ParentService(ParentRepository()),
    ),
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
];


dynamic get providers => _providers;