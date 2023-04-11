// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:consultant/models/exercise_model.dart';

class Submission extends Equatable {
  final String exerciseId;
  final String studentId;
  final List<FileName> fileNames;
  final double? point;
  final String? id;
  final DateTime timeCreated;
  final String? consultantComment;
  const Submission({
    required this.studentId,
    required this.exerciseId,
    required this.fileNames,
    required this.timeCreated,
    this.consultantComment,
    this.point,
    this.id,
  });

  Submission copyWith({
    String? exerciseId,
    String? studentId,
    List<FileName>? fileNames,
    double? point,
    String? id,
    DateTime? timeCreated,
    String? consultantComment,
  }) {
    return Submission(
      exerciseId: exerciseId ?? this.exerciseId,
      studentId: studentId ?? this.studentId,
      fileNames: fileNames ?? this.fileNames,
      point: point ?? this.point,
      id: id ?? this.id,
      timeCreated: timeCreated ?? this.timeCreated,
      consultantComment:  consultantComment ?? this.consultantComment,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'exerciseId': exerciseId,
      'fileNames': fileNames.map((e) => e.toJson()).toList(),
      'point': point,
      'studentId': studentId,
      'consultantComment': consultantComment,
      'timeCreated': timeCreated
    };
  }

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      studentId: json['studentId'] as String,
      exerciseId: json['exerciseId'] as String,
      fileNames:
          (json['fileNames'] as List).map((e) => FileName.fromJson(e)).toList(),
      point: json['point'] != null ? json['point'] as double : null,
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      consultantComment: json['consultantComment'] as String?,
    );
  }

  @override
  List<Object> get props => [exerciseId, fileNames, studentId, timeCreated];
}
