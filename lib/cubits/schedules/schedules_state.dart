import 'package:consultant/models/schedule_model.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleFetched extends ScheduleState {
  final List<Schedule> schedules;
  ScheduleFetched(this.schedules);
}

class ScheduleLoading extends ScheduleState {}

class ScheduleBooked extends ScheduleState {}
