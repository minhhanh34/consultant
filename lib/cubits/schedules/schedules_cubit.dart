import 'package:consultant/cubits/schedules/schedules_state.dart';
import 'package:consultant/models/schedule_model.dart';
import 'package:consultant/services/schedule_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this._service) : super(ScheduleInitial());
  final ScheduleService _service;
  List<Schedule>? _schedules;
  Schedule? _scheduleUndo;
  int _undoIndex = -1;

  void fetchSchedules(String id) async {
    emit(ScheduleLoading());
    _schedules ??= await _service.fetchParentSchedules(id);
    emit(ScheduleFetched(_schedules!));
  }

  Future bookSchedule(Schedule schedule) async {
    emit(ScheduleLoading());
    final newSchedule = await _service.createSchedule(schedule);
    _schedules?.add(newSchedule);
    emit(ScheduleBooked());
  }

  Future<bool> cancelSchedule(Schedule schedule) async {
    _scheduleUndo = await _service.deleteSchedule(schedule);
    _undoIndex = _schedules!.indexOf(schedule);
    _schedules?.remove(schedule);
    emit(ScheduleFetched(_schedules!));
    return true;
  }

  void undoSchedule() async {
    if (_scheduleUndo != null) {
      final newSchedule = await _service.createSchedule(_scheduleUndo!);
      _schedules?.insert(_undoIndex, newSchedule);
      _scheduleUndo = null;
      _undoIndex = -1;
      emit(ScheduleFetched(_schedules!));
    }
  }

  void dispose() {
    _scheduleUndo = null;
    _schedules = null;
    _undoIndex = -1;
    emit(ScheduleInitial());
  }
}
