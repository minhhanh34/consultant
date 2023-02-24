import 'package:consultant/models/consultant.dart';
import 'package:consultant/services/consultant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.consultantService}) : super(HomeInitial());
  final ConsultantService consultantService;

  List<Consultant>? consultants;

  Future<void> getConsultants() async { 
    emit(HomeLoading());
    consultants ??= await consultantService.getConsultants();
    emit(HomeConsultants(consultants!));
  }
}
