import 'package:consultant/models/parent_model.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState{}

class SettingsParentFetched extends SettingsState {
  final Parent parent;
  SettingsParentFetched(this.parent);
}
class SettingsLoading extends SettingsState {}