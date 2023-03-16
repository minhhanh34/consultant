import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant/cubits/app/app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(Home());

  int _bottomAppBarIndex = 0;

  int get bottomAppBarIndex => _bottomAppBarIndex;

  void home() => emit(Home());
  void messages() => emit(Messages());
  void schedules() => emit(Schedules());
  void settings() => emit(Settings());
  void searching() => emit(Searching());

  void handle(int value) {
    _bottomAppBarIndex = value;
    if (value == 0) home();
    if (value == 1) searching();
    if (value == 2) messages();
    if (value == 3) schedules();
    if (value == 4) settings();
  }

  void setBottomAppBarIndex(int val) {
    handle(val);
  }
}
