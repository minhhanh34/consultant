// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:consultant/models/class_model.dart';
import 'package:consultant/models/schedule_model.dart';

abstract class ConsultantHomeState {}

class ConsultantHomeInitial extends ConsultantHomeState {}

class ConsultantHomeLoading extends ConsultantHomeState {}

class ConsultantHomeFetched extends ConsultantHomeState {
  final List<Schedule> schedules;
  final List<Class> classes;
  ConsultantHomeFetched(this.schedules, this.classes);

  ConsultantHomeFetched copyWith({
    List<Schedule>? schedules,
    List<Class>? classes,
  }) {
    return ConsultantHomeFetched(
      schedules ?? this.schedules,
      classes ?? this.classes,
    );
  }
}
