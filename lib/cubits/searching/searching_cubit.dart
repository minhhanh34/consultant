import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant/cubits/searching/searching_state.dart';

class SearchingCubit extends Cubit<SearchingState> {
  SearchingCubit(this._service) : super(SearchingInitial());

  final ConsultantService _service;
  List<Consultant>? _consultants;

  void featchAllConsultants() async {
    emit(SearchingLoading());
    _consultants ??= await _service.getConsultants();
    emit(SearchingConsultants(_consultants!));
  }

  void filter(String text) async {
    final filteredConsultants = _consultants!
        .where((consultant) =>
            consultant.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
    emit(SearchingConsultants(filteredConsultants));
  }
  void dispose() {
    _consultants = null;
    emit(SearchingInitial());
  }

}
