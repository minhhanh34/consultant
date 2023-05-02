import 'package:consultant/cubits/app/app_cubit.dart';
import 'package:consultant/cubits/chat/chat_cubit.dart';
import 'package:consultant/cubits/consultant_app/consultant_app_cubit.dart';
import 'package:consultant/cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/cubits/consultant_settings/consultant_settings_cubit.dart';
import 'package:consultant/cubits/enroll/enroll_cubit.dart';
import 'package:consultant/cubits/filter/filter_cubit.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/cubits/parent_class/parent_class_cubit.dart';
import 'package:consultant/cubits/posts/post_cubit.dart';
import 'package:consultant/cubits/schedules/schedules_cubit.dart';
import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:consultant/cubits/settings/settings_cubit.dart';
import 'package:consultant/cubits/student_class/student_class_cubit.dart';
import 'package:consultant/cubits/student_home/student_home_cubit.dart';
import 'package:consultant/services/auth_service.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/parent_service.dart';
import 'package:consultant/services/student_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/user_types.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._service,
    this._consultantService,
    this._parentService,
    this._studentService,
  ) : super(AuthInitial());
  final AuthService _service;
  final ConsultantService _consultantService;
  final ParentService _parentService;
  final StudentService _studentService;
  static UserCredential? _userCredential;
  static String? _userType;
  static String? _uid;
  static String? _currentUserId;
  static bool? _infoUpdated;

  static set setInfoUpdated(bool isUpdated) => _infoUpdated = isUpdated;

  static set setCurrentUserId(String id) => _currentUserId = id;

  static set setUid(String uid) => _uid = uid;

  static set setUserType(String userType) => _userType = userType;

  static String? get currentUserId => _currentUserId;

  static String? get uid => _uid;

  static String? get userType => _userType;

  static bool? get infoUpdated => _infoUpdated;

  static UserCredential? get userCredential => _userCredential;

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    _userCredential = await _service.signIn(email, password);
    if (userCredential == null) {
      emit(AuthInvalid());
      return;
    }

    _uid = userCredential?.user?.uid;
    _userType = userCredential
        ?.user?.displayName; // display name was stored as user type
    // photo url was stored as info update
    if (userCredential?.user?.photoURL == 'new') {
      _infoUpdated = false;
    } else {
      _infoUpdated = true;
    }
    await secureStorage.write(key: 'uid', value: uid);
    await secureStorage.write(key: 'userType', value: userType);
    await secureStorage.write(
        key: 'infoUpdated', value: infoUpdated.toString());
    if (_userType == 'consultant') {
      final consultant = await _consultantService.getConsultantByUid(_uid!);
      _currentUserId = consultant.id!;
      await secureStorage.write(key: 'id', value: currentUserId);
      if (_infoUpdated == false || _infoUpdated == null) {
        emit(AuthUpdateConsultant(consultant));
        return;
      }
      emit(AuthSignInConsultant(consultant));
      return;
    }
    if (_userType == 'parent') {
      final parent = await _parentService.getParentByUid(_uid!);
      _currentUserId = parent.id!;
      await secureStorage.write(key: 'id', value: currentUserId);
      if (_infoUpdated == false || _infoUpdated == null) {
        emit(AuthUpdateParent(parent));
        return;
      }
      emit(AuthSignInParent(parent));
      return;
    }
    if (_userType == 'student') {
      final student = await _studentService.getStudentByUid(_uid!);
      _currentUserId = student.id!;
      await secureStorage.write(key: 'id', value: currentUserId);
      if (_infoUpdated == false || _infoUpdated == null) {
        emit(AuthUpdateStudent(student));
        return;
      }
      emit(AuthSignInStudent(student));
      return;
    }
    emit(AuthInvalid());
  }

  Future<void> createUser({
    required UserType userType,
    required String email,
    required String password,
    String? parentId,
  }) async {
    emit(AuthLoading());
    final result = await _service.createUser(
      userType: userType,
      email: email,
      password: password,
      parentIdForStudentUser: parentId,
    );
    if (result == null) {
      emit(AuthMessage('Đăng ký không thành công'));
      return;
    }
    emit(AuthSignUpSuccessed());
    emit(AuthInitial());
  }

  Future<void> signOut(BuildContext context) async {
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final appCubit = context.read<AppCubit>();
    final authCubit = context.read<AuthCubit>();
    final chatCubit = context.read<ChatCubit>();
    final consultantAppCubit = context.read<ConsultantAppCubit>();
    final classCubit = context.read<ClassCubit>();
    final consultantHomeCubit = context.read<ConsultantHomeCubit>();
    final consultantSettingsCubit = context.read<ConsultantSettingsCubit>();
    final enrollCubit = context.read<EnrollCubit>();
    final filterCubit = context.read<FilterCubit>();
    final homeCubit = context.read<HomeCubit>();
    final messageCubit = context.read<MessageCubit>();
    final postCubit = context.read<PostCubit>();
    final scheduleCubit = context.read<ScheduleCubit>();
    final searchCubit = context.read<SearchingCubit>();
    final settingsCubit = context.read<SettingsCubit>();
    final studentClassCubit = context.read<StudentClassCubit>();
    final studentHomeCubit = context.read<StudentHomeCubit>();
    final parentClassCubit = context.read<ParentClassCubit>();
    emit(AuthLoading());
    await _service.signOut();
    await secureStorage.deleteAll();
    emit(AuthSignOuted());
    authCubit.dispose();
    appCubit.dispose();
    chatCubit.dispose();
    consultantAppCubit.dispose();
    classCubit.dispose();
    consultantHomeCubit.dispose();
    consultantSettingsCubit.dispose();
    filterCubit.dispose();
    homeCubit.dispose();
    messageCubit.dispose();
    postCubit.dispose();
    scheduleCubit.dispose();
    searchCubit.dispose();
    settingsCubit.dispose();
    enrollCubit.dispose();
    studentClassCubit.dispose();
    studentHomeCubit.dispose();
    parentClassCubit.dispose();
  }

  void dispose() {
    _uid = null;
    _userType = null;
    _currentUserId = null;
    _userCredential = null;
    _infoUpdated = null;
    emit(AuthInitial());
  }
}
