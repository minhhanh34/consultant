import 'package:consultant/cubits/app/app_cubit.dart';
import 'package:consultant/cubits/chat/chat_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_app/consultant_app_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_class/class_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_settings/consultant_settings_cubit.dart';
import 'package:consultant/cubits/filter/filter_cubit.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/cubits/posts/post_cubit.dart';
import 'package:consultant/cubits/schedules/schedules_cubit.dart';
import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:consultant/cubits/settings/settings_cubit.dart';
import 'package:consultant/services/auth_service.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/parent_service.dart';
import 'package:consultant/services/student_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/user_type_enum.dart';
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
  UserCredential? _userCredential;
  static String _currentUserId = '';

  static String get currentUserId => _currentUserId;

  UserCredential? get userCredential => _userCredential;

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    _userCredential = await _service.signIn(email, password);
    if (_userCredential == null) {
      emit(AuthInvalid());
      return;
    }
    final uid = _userCredential!.user!.uid;
    final userType = userCredential!.user!.displayName;
    if (userType == 'consultant') {
      final consultant = await _consultantService.getConsultantByUid(uid);
      _currentUserId = consultant.id!;
      emit(AuthSignInConsultant(consultant));
      return;
    }
    if (userType == 'parent') {
      final parent = await _parentService.getParentByUid(uid);
      _currentUserId = parent.id!;
      emit(AuthSignInParent(parent));
      return;
    }
    if (userType == 'student') {
      final student = await _studentService.getStudentByUid(uid);
      _currentUserId = student.id!;
      emit(AuthSignInStudent(student));
      return;
    }
    emit(AuthInvalid());
  }

  Future<void> createUser({
    required UserType userType,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    await _service.createUser(userType, email, password);
    emit(AuthSignUpSuccessed());
    emit(AuthInitial());
  }

  Future<void> signOut(BuildContext context) async {
    emit(AuthLoading());
    _service.signOut().then((value) {
      emit(AuthSignOuted());
      context.read<AppCubit>().dispose();
      context.read<AuthCubit>().dispose();
      context.read<ChatCubit>().dispose();
      context.read<ConsultantAppCubit>().dispose();
      context.read<ClassCubit>().dispose();
      context.read<ConsultantHomeCubit>().dispose();
      context.read<ConsultantSettingsCubit>().dispose();
      context.read<FilterCubit>().dispose();
      context.read<HomeCubit>().dispose();
      context.read<MessageCubit>().dispose();
      context.read<PostCubit>().dispose();
      context.read<ScheduleCubit>().dispose();
      context.read<SearchingCubit>().dispose();
      context.read<SettingsCubit>().dispose();
    });
    emit(AuthSignOuted());
  }

  void dispose() {
    _userCredential = null;
    emit(AuthInitial());
  }
}
