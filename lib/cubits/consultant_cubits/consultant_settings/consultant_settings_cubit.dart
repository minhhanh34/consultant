import 'package:consultant/cubits/consultant_cubits/consultant_settings/consultant_settings_state.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultantSettingsCubit extends Cubit<ConsultantSettingsState> {
  ConsultantSettingsCubit(this._service) : super(ConsultantSettingsInitial());
  final ConsultantService _service;
  Consultant? _consultant;

  Future<void> fetchData(String id) async {
    emit(ConsultantSettingsLoading());
    _consultant ??= await _service.get(id);
    emit(ConsultantSettingsFetched(_consultant!));
  }

  void dispose() {
    _consultant = null;
    emit(ConsultantSettingsInitial());
  }
}
