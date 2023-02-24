import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:consultant/cubits/app/app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(Home());

  int bottomAppBarIndex = 0;

  void home() => emit(Home());
  void messages() => emit(Messages());
  void schedules() => emit(Schedules());
  void settings() => emit(Settings());

  void handle(int value) {
    bottomAppBarIndex = value;
    if (value == 0) home();
    if (value == 1) messages();
    if (value == 2) schedules();
    if (value == 3) settings();
  }
}
