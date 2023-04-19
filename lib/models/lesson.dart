// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Lesson extends Equatable {
  final String? id;
  final DateTime begin;
  final DateTime end;
  final int dayOfWeek;
  final int duration;
  final String consultantId;
  final String parentId;
  final List<String> studentIds;
  final String? commentOfConsultant;
  final String? commentOfParent;
  final String? subjectName;
  final String classId;
  const Lesson({
    this.id,
    required this.begin,
    required this.end,
    required this.dayOfWeek,
    required this.duration,
    required this.consultantId,
    required this.parentId,
    required this.studentIds,
    this.commentOfConsultant,
    this.commentOfParent,
    this.subjectName,
    required this.classId,
  });

  Lesson copyWith({
    String? id,
    DateTime? begin,
    DateTime? end,
    int? dayOfWeek,
    int? duration,
    String? consultantId,
    String? parentId,
    List<String>? studentIds,
    String? commentOfConsultant,
    String? commentOfParent,
    String? subjectName,
    String? classId,
  }) {
    return Lesson(
      id: id ?? this.id,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      duration: duration ?? this.duration,
      consultantId: consultantId ?? this.consultantId,
      parentId: parentId ?? this.parentId,
      studentIds: studentIds ?? this.studentIds,
      commentOfConsultant: commentOfConsultant ?? this.commentOfConsultant,
      commentOfParent: commentOfParent ?? this.commentOfParent,
      subjectName: subjectName ?? this.subjectName,
      classId: classId ?? this.classId,
    );
  }

  @override
  List<Object> get props {
    return [
      begin,
      end,
      dayOfWeek,
      duration,
      consultantId,
      parentId,
      studentIds,
      classId,
    ];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'begin': begin,
      'end': end,
      'dayOfWeek': dayOfWeek,
      'duration': duration,
      'consultantId': consultantId,
      'parentId': parentId,
      'studentIds': studentIds,
      'commentOfConsultant': commentOfConsultant,
      'commentOfParent': commentOfParent,
      'subjectName': subjectName,
      'classId': classId,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      begin: (json['begin'] as Timestamp).toDate(),
      end: (json['end'] as Timestamp).toDate(),
      dayOfWeek: json['dayOfWeek'] as int,
      duration: json['duration'],
      consultantId: json['consultantId'] as String,
      parentId: json['parentId'] as String,
      studentIds:
          (json['studentIds'] as List).map((id) => id as String).toList(),
      commentOfConsultant: json['commentOfConsultant'] as String?,
      commentOfParent: json['commentOfParent'] as String?,
      subjectName: json['subjectName'] as String?,
      classId: json['classId'] as String,
    );
  }
}
