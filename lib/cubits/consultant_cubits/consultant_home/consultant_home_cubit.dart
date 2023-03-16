
import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_state.dart';
import 'package:consultant/models/class_model.dart';
import 'package:consultant/models/schedule_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:consultant/services/schedule_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultantHomeCubit extends Cubit<ConsultantHomeState> {
  ConsultantHomeCubit(
    this._scheduleService,
    this._classService,
  ) : super(ConsultantHomeInitial());

  final ScheduleService _scheduleService;
  final ClassService _classService;
  List<Schedule>? _schedules;
  List<Class>? _classes;
  Schedule? scheduleUndo;
  int scheduleUndoIndex = -1;
  int _navIndex = 0;
  bool _headerChipSelected = false;

  int get navIndex => _navIndex;
  bool get headerChipSelected => _headerChipSelected;

  void changeNavIndex(int value) => _navIndex = value;

  void changeHeaderChip(bool value) => _headerChipSelected = value;

  Future<void> fetchData(String id) async {
    emit(ConsultantHomeLoading());
    _schedules ??= await _scheduleService.fetchConsultantSchedules(id);
    _classes ??= await _classService.fetchClasses(id);
    emit(ConsultantHomeFetched(_schedules!, _classes!));
  }

  Future<bool> denySchedule(Schedule schedule) async {
    emit(ConsultantHomeLoading());
    scheduleUndo = await _scheduleService.deleteSchedule(schedule);
    scheduleUndoIndex = _schedules!.indexOf(schedule);
    _schedules?.remove(schedule);
    emit(ConsultantHomeFetched(_schedules!, _classes!));
    return true;
  }

  Future<void> undoScheduleDeny() async {
    if (scheduleUndo != null && scheduleUndoIndex != -1) {
      final newSchedule = await _scheduleService.createSchedule(scheduleUndo!);
      _schedules?.insert(scheduleUndoIndex, newSchedule);
      emit(ConsultantHomeFetched(_schedules!, _classes!));
    }
  }

  Future<void> createClass(Class consultantClass) async {
    emit(ConsultantHomeLoading());
    final newClass = await _classService.create(consultantClass);
    _classes?.add(newClass);
    emit(ConsultantHomeFetched(_schedules!, _classes!));
  }

  Future<bool> deleteClass(Class cla) async {
    emit(ConsultantHomeLoading());
    final result = await _classService.delete(cla.id!);
    if (result) {
      _classes?.remove(cla);
    }
    emit(ConsultantHomeFetched(_schedules!, _classes!));
    return result;
  }

  void confirmSchedule(Schedule schedule) async {
    emit(ConsultantHomeLoading());
    await _scheduleService.update(schedule);
    emit(ConsultantHomeFetched(_schedules!, _classes!));
  }
}
