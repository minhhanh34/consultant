import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/settings/settings_state.dart';
import 'package:consultant/models/parent_model.dart';
import 'package:consultant/services/settings_service.dart';
import 'package:consultant/services/student_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/class_model.dart';
import '../../models/student_model.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._service, this._studentService) : super(SettingsInitial());
  final SettingsService _service;
  final StudentService _studentService;
  Parent? _parent;
  List<Class>? _classes;
  List<Student>? _children;
  Future<Parent> create(Parent parent) async {
    return await _service.create(parent);
  }

  Future<void> fetchPatent(String id) async {
    emit(SettingsLoading());
    _parent ??= await _service.fetchParent(id);
    _children ??= await _studentService.query('parentId',
        isEqualTo: AuthCubit.currentUserId);
    _classes ??= await _service.fetchClassesForParent(AuthCubit.currentUserId!);
    emit(SettingsParentFetched(_parent!, _children!, _classes!));
  }

  Future<void> updateParentInfo(String id, Parent parent) async {
    await _service.updateParentInfo(id, parent);
    _parent = null;
    await fetchPatent(id);
  }

  Future<void> onRelationShip() async {
    // emit(SettingsRelationShip());
  }

  Future<void> refresh() async {
    _parent = null;
    _classes = null;
    _children = null;
    await fetchPatent(AuthCubit.currentUserId!);
  }

  void dispose() {
    _children = null;
    _classes = null;
    _parent = null;
    emit(SettingsInitial());
  }
}
