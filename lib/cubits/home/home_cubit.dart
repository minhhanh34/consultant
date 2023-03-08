import 'package:consultant/models/consultant.dart';
import 'package:consultant/services/consultant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._consultantService) : super(HomeInitial());
  final ConsultantService _consultantService;
  List<Consultant>? _consultants;

  Future<void> getConsultants() async {
    emit(HomeLoading());
    _consultants ??= await _consultantService.getConsultants();
    emit(HomeConsultants(_consultants!));
  }

  Future<Consultant> fetchComments(Consultant consultant) async {
    // emit(HomeLoading());
    final comments = await _consultantService.getComments(consultant.id!);
    consultant.setComments(comments);
    return consultant;
    // emit(HomeConsultant(consultant));
    // emit(HomeConsultants(_consultants!));
  }
}
