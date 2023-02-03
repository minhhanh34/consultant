import 'package:consultant/cubits/consultant/consultant_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultantCubit extends Cubit<ConsultantState> {
  ConsultantCubit() : super(ConsultantInitial());
}
