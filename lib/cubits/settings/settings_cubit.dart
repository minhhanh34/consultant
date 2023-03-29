import 'package:consultant/cubits/settings/settings_state.dart';
import 'package:consultant/models/parent_model.dart';
import 'package:consultant/services/settings_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._service) : super(SettingsInitial());
  final SettingsService _service;

  Parent? _parent;

  static const parentId = 'Hcf1IhArIcwq33RTseoG';
  Future<Parent> create(Parent parent) async {
    return await _service.create(parent);
  }

  Future<void> fetchPatent(String id) async {
    emit(SettingsLoading());
    _parent ??= await _service.fetchParent(id);
    emit(SettingsParentFetched(_parent!));
  }

  void dispose() {
    _parent = null;
    emit(SettingsInitial());
  }
}
