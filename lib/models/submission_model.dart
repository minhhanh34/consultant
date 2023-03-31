// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import 'package:consultant/models/exercise_model.dart';

class Submission extends Equatable {
  final String exerciseId;
  final String studentId;
  final List<FileName> fileNames;
  final int? point;
  final String? id;
  const Submission({
    required this.studentId,
    required this.exerciseId,
    required this.fileNames,
    this.point,
    this.id,
  });

  Submission copyWith({
    String? exerciseId,
    String? studentId,
    List<FileName>? fileNames,
    int? point,
    String? id,
  }) {
    return Submission(
      exerciseId: exerciseId ?? this.exerciseId,
      studentId: studentId ?? this.studentId,
      fileNames: fileNames ?? this.fileNames,
      point: point ?? this.point,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'exerciseId': exerciseId,
      'fileNames': fileNames.map((e) => e.toJson()).toList(),
      'point': point,
      'studentId': studentId,
    };
  }

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      studentId: json['studentId'] as String,
      exerciseId: json['exerciseId'] as String,
      fileNames:
          (json['fileNames'] as List).map((e) => FileName.fromJson(e)).toList(),
      point: json['point'] != null ? json['point'] as int : null,
    );
  }

  @override
  List<Object> get props => [exerciseId, fileNames, studentId];
}
