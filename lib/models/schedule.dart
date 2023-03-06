import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Schedule extends Equatable {
  final String consultantName;
  final String subjectName;
  final DateTime dateTime;
  final ScheduleStates state;
  final String? id;
  const Schedule({
    this.id,
    required this.consultantName,
    required this.subjectName,
    required this.dateTime,
    required this.state,
  });

  Schedule copyWith({
    String? id,
    String? consultantName,
    String? subjectName,
    DateTime? dateTime,
    ScheduleStates? state,
  }) {
    return Schedule(
      id: id ?? this.id,
      consultantName: consultantName ?? this.consultantName,
      subjectName: subjectName ?? this.subjectName,
      dateTime: dateTime ?? this.dateTime,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'consultantName': consultantName,
      'subjectName': subjectName,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'state': state.index,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      consultantName: json['consultantName'] as String,
      subjectName: json['subjectName'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime'] as int),
      state: convertState(json['state']),
    );
  }

  @override
  List<Object?> get props => [id, consultantName, subjectName, dateTime, state];

  static ScheduleStates convertState(int value) {
    if (value == 0) return ScheduleStates.upComing;
    if (value == 1) return ScheduleStates.completed;
    return ScheduleStates.canceled;
  }
}

enum ScheduleStates {
  upComing,
  completed,
  canceled,
}
