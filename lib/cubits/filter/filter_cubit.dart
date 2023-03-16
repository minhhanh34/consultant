import 'package:consultant/services/consultant_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_state.dart';



class FilterCubit extends Cubit<FilterState> {
  FilterCubit(this._service) : super(FilterInitial());

  final ConsultantService _service;

  void applyFilter(List<String> filter) async {
    emit(FilterLoading());
    final filteredConsultants = await _service.applyFilter(filter);
    emit(FilteredConsultants(filteredConsultants));
  }
}
