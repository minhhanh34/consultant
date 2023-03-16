import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._consultantService) : super(HomeInitial());
  final ConsultantService _consultantService;

  List<Consultant>? popularConsultants;

  Future<void> fetchPopularConsultants() async {
    emit(HomeLoading());
    popularConsultants ??= await _consultantService.getPopularConsultants();
    emit(HomeConsultants(popularConsultants!));
  }

  Future<Consultant> fetchComments(Consultant consultant) async {
    final comments = await _consultantService.getComments(consultant.id!);
    consultant.setComments(comments);
    return consultant;
  }
}
