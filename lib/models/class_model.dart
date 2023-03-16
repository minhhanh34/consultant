// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:consultant/models/subject_model.dart';

@immutable
class Class extends Equatable {
  final String? id;
  final String consultantId;
  final String consultantName;
  final Subject subject;
  final int studentSize;
  final String avtPath;
  final String name;
  const Class({
    this.id,
    required this.consultantId,
    required this.consultantName,
    required this.subject,
    required this.studentSize,
    required this.avtPath,
    required this.name,
  });

  Class copyWith({
    String? id,
    String? consultantId,
    String? consultantName,
    Subject? subject,
    int? studentSize,
    String? avtPath,
    String? name,
  }) {
    return Class(
      id: id ?? this.id,
      consultantId: consultantId ?? this.consultantId,
      consultantName: consultantName ?? this.consultantName,
      subject: subject ?? this.subject,
      studentSize: studentSize ?? this.studentSize,
      avtPath: avtPath ?? this.avtPath,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props {
    return [
      consultantId,
      consultantName,
      subject,
      studentSize,
      avtPath,
      name,
    ];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'consultantId': consultantId,
      'consultantName': consultantName,
      'subject': subject.toJson(),
      'studentSize': studentSize,
      'avtPath': avtPath,
      'name': name,
    };
  }

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] != null ? json['id'] as String : null,
      consultantId: json['consultantId'] as String,
      consultantName: json['consultantName'] as String,
      subject: Subject.fromJson(json['subject'] as Map<String, dynamic>),
      studentSize: json['studentSize'] as int,
      avtPath: json['avtPath'] as String,
      name: json['name'] as String,
    );
  }
}
