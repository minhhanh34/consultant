import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/views/components/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant/cubits/searching/searching_state.dart';

class SearchingCubit extends Cubit<SearchingState> {
  SearchingCubit(this._service) : super(SearchingInitial());

  final ConsultantService _service;
  List<Consultant>? _consultants;

  void featchAllConsultants() async {
    emit(SearchingLoading());
    _consultants ??= await _service.getConsultants();
    emit(
      SearchingConsultants(consultants: _consultants!),
    );
  }

  void filterByName(String text) async {
    final filteredConsultants = _consultants!
        .where((consultant) =>
            consultant.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
    emit(
      SearchingConsultants(consultants: filteredConsultants),
    );
  }

  Future<void> search({
    required List<String> subjects,
    required RangeValues priceRange,
    required Gender gender,
    required RangeValues rateRange,
    required RangeValues classRange,
    required String location,
  }) async {
    emit(SearchingLoading());
    final consultants = await _service.query(
      subjects,
      priceRange,
      gender,
      rateRange,
      classRange,
      location,
    );
    emit(
      SearchingConsultants(
        consultants: consultants,
        isFiltering: true,
      ),
    );
  }

  void dispose() {
    _consultants = null;
    emit(SearchingInitial());
  }
}
