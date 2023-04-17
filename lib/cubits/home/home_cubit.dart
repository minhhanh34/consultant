import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/parent_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/parent_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._consultantService, this._parentService)
      : super(HomeInitial());
  final ConsultantService _consultantService;
  final ParentService _parentService;
  List<Consultant>? _popularConsultants;
  Parent? _parent;

  Future<void> fetchPopularConsultants() async {
    _popularConsultants ??= await _consultantService.getPopularConsultants();
  }

  Future<Consultant> fetchComments(Consultant consultant) async {
    final comments = await _consultantService.getComments(consultant.id!);
    consultant.setComments(comments);
    return consultant;
  }

  Future<void> onInitialize(String parentUid) async {
    emit(HomeLoading());
    await fetchPopularConsultants();
    _parent ??= await _parentService.getParentByUid(parentUid);
    emit(HomeConsultants(_popularConsultants!, _parent!));
  }

  Future<void> refresh() async {
    _popularConsultants = null;
    _parent = null;
    await onInitialize(AuthCubit.uid!);
  }

  void dispose() {
    _popularConsultants = null;
    _parent = null;
    emit(HomeInitial());
  }
}
