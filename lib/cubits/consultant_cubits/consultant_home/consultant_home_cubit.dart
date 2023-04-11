import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_state.dart';
import 'package:consultant/models/class_model.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/models/schedule_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultantHomeCubit extends Cubit<ConsultantHomeState> {
  ConsultantHomeCubit(
    this._consultantService,
    this._scheduleService,
    this._classService,
  ) : super(ConsultantHomeInitial());

  final ScheduleService _scheduleService;
  final ClassService _classService;
  final ConsultantService _consultantService;

  List<Schedule>? _schedules;
  List<Class>? _classes;
  Schedule? _scheduleUndo;
  int _scheduleUndoIndex = -1;
  int _navIndex = 0;
  bool _headerChipSelected = false;
  Consultant? _consultant;

  int get navIndex => _navIndex;
  bool get headerChipSelected => _headerChipSelected;

  void changeNavIndex(int value) => _navIndex = value;

  void changeHeaderChip(bool value) => _headerChipSelected = value;

  Future<void> fetchData(String id) async {
    _consultant ??= await _consultantService.get(id);
    _schedules ??= await _scheduleService.fetchConsultantSchedules(id);
    _classes ??= await _classService.fetchClasses(id);
  }

  Future<void> initialize(BuildContext context, String userId) async {
    emit(ConsultantHomeLoading());
    await fetchData(userId);
    emit(ConsultantHomeFetched(_consultant!, _schedules!, _classes!));
  }

  Future<bool> denySchedule(Schedule schedule) async {
    emit(ConsultantHomeLoading());
    _scheduleUndo = await _scheduleService.deleteSchedule(schedule);
    _scheduleUndoIndex = _schedules!.indexOf(schedule);
    _schedules?.remove(schedule);
    emit(ConsultantHomeFetched(_consultant!, _schedules!, _classes!));
    return true;
  }

  Future<void> undoScheduleDeny() async {
    if (_scheduleUndo != null && _scheduleUndoIndex != -1) {
      final newSchedule = await _scheduleService.createSchedule(_scheduleUndo!);
      _schedules?.insert(_scheduleUndoIndex, newSchedule);
      emit(ConsultantHomeFetched(_consultant!, _schedules!, _classes!));
    }
  }

  Future<void> createClass(Class consultantClass) async {
    emit(ConsultantHomeLoading());
    final newClass = await _classService.create(consultantClass);
    _classes?.add(newClass);
    emit(ConsultantHomeFetched(_consultant!, _schedules!, _classes!));
  }

  Future<bool> deleteClass(Class cla) async {
    emit(ConsultantHomeLoading());
    await _classService.deleteExerciseCollection(cla.id!);
    await _classService.deleteStudentCollection(cla.id!);
    final result = await _classService.delete(cla.id!);
    if (result) {
      _classes?.remove(cla);
    }
    emit(ConsultantHomeFetched(_consultant!, _schedules!, _classes!));
    return result;
  }

  void confirmSchedule(Schedule schedule) async {
    emit(ConsultantHomeLoading());
    await _scheduleService.update(schedule);
    emit(ConsultantHomeFetched(_consultant!, _schedules!, _classes!));
  }

  Future<void> updateConsultantInfo(String id, Consultant consultant) async {
    await _consultantService.update(id, consultant);
  }

  void dispose() {
    _classes = null;
    _schedules = null;
    _scheduleUndo = null;
    _scheduleUndoIndex = -1;
    _navIndex = 0;
    _headerChipSelected = false;
    _consultant = null;
    emit(ConsultantHomeInitial());
  }
}
