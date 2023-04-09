import 'package:flutter_bloc/flutter_bloc.dart';

import 'consultant_app_state.dart';

class ConsultantAppCubit extends Cubit<ConsultantAppState> {
  ConsultantAppCubit() : super(ConsultantHome());

  int _bottomAppBarIndex = 0;

  int get bottomAppBarIndex => _bottomAppBarIndex;

  void home() => emit(ConsultantHome());
  void posts() => emit(ConsultantPost());
  void message() => emit(ConsultantMessage());
  void settings() => emit(ConsultantSettings());

  void handle(int value) {
    _bottomAppBarIndex = value;
    if (value == 0) home();
    if (value == 1) posts();
    if (value == 2) message();
    if (value == 3) settings();
  }

  void setBottomAppBarIndex(int val) {
    handle(val);
  }

  void dispose() {
    _bottomAppBarIndex = 0;
    emit(ConsultantHome());
  }
}
