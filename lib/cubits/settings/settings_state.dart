import 'package:consultant/models/parent_model.dart';
import 'package:consultant/models/student_model.dart';

import '../../models/class_model.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsParentFetched extends SettingsState {
  final Parent parent;
  final List<Student> children;
  final List<Class> classes;
  SettingsParentFetched(this.parent, this.children, this.classes);
}

class SettingsLoading extends SettingsState {}
