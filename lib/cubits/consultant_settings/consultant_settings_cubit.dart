import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/consultant_settings/consultant_settings_state.dart';
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
    final comments = await _service.getComments(_consultant!.id!);
    _consultant?.comments.addAll(comments);
    emit(ConsultantSettingsFetched(_consultant!));
  }

  Future<void> updateConsultantInfo(String id, Consultant consultant) async {
    await _service.update(id, consultant);
    _consultant = null;
    fetchData(id);
  }

  Future<void> onRefresh() async {
    _consultant = null;
    fetchData(AuthCubit.currentUserId!);
  }

  void dispose() {
    _consultant = null;
    emit(ConsultantSettingsInitial());
  }
}
