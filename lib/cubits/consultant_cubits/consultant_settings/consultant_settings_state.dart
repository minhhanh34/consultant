import '../../../models/consultant_model.dart';

abstract class ConsultantSettingsState {}

class ConsultantSettingsLoading extends ConsultantSettingsState {}

class ConsultantSettingsInitial extends ConsultantSettingsState {}

class ConsultantSettingsFetched extends ConsultantSettingsState {
  final Consultant consultant;
  ConsultantSettingsFetched(this.consultant);
}
