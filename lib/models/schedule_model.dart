import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Schedule extends Equatable {
  final String consultantName;
  final String subjectName;
  final DateTime dateTime;
  final ScheduleStates state;
  final String? id;
  final String parentId;
  final String consultantId;
  const Schedule({
    this.id,
    required this.parentId,
    required this.consultantId,
    required this.consultantName,
    required this.subjectName,
    required this.dateTime,
    this.state = ScheduleStates.upComing,
  });

  Schedule copyWith({
    String? id,
    String? consultantName,
    String? subjectName,
    DateTime? dateTime,
    ScheduleStates? state,
    String? parentId,
    String? consultantId,
  }) {
    return Schedule(
      id: id ?? this.id,
      consultantName: consultantName ?? this.consultantName,
      subjectName: subjectName ?? this.subjectName,
      dateTime: dateTime ?? this.dateTime,
      state: state ?? this.state,
      parentId: parentId ?? this.parentId,
      consultantId: consultantId ?? this.consultantId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'consultantName': consultantName,
      'subjectName': subjectName,
      'dateTime': dateTime,
      'state': state.index,
      'parentId': parentId,
      'consultantId': consultantId,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      consultantName: json['consultantName'] as String,
      subjectName: json['subjectName'] as String,
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      state: convertState(json['state']),
      consultantId: json['consultantId'],
      parentId: json['parentId'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        consultantName,
        subjectName,
        dateTime,
        state,
        parentId,
        consultantId,
      ];

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
  confirmed,
  waiting,
}
