import 'package:consultant/models/parent_model.dart';
import 'package:consultant/models/student_model.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsParentFetched extends SettingsState {
  final Parent parent;
  final List<Student> children;
  SettingsParentFetched(this.parent, this.children);
}

class SettingsLoading extends SettingsState {}
