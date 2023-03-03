import 'package:consultant/models/consultant.dart';
import 'package:consultant/services/consultant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant/cubits/searching/searching_state.dart';

class SearchingCubit extends Cubit<SearchingState> {
  SearchingCubit({required this.service}) : super(SearchingInitial());

  final ConsultantService service;
  List<Consultant>? consultants;

  void featchAllConsultants() async {
    emit(SearchingLoading());
    consultants ??= await service.getConsultants();
    emit(SearchingConsultants(consultants!));
  }

  void filter(String text) async {
    final filteredConsultants = consultants!
        .where((consultant) => consultant.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
    emit(SearchingConsultants(filteredConsultants));
  }
}
