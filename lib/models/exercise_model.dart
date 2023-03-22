// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Exercise extends Equatable {
  final String? id;
  final String? title;
  final List<String>? fileUrls;
  final DateTime timeCreated;
  final DateTime? timeIsUp;
  const Exercise({
    required this.timeCreated,
    this.id,
    this.title,
    this.fileUrls,
    this.timeIsUp,
  });

  Exercise copyWith({
    String? id,
    String? title,
    List<String>? fileUrls,
    DateTime? timeCreated,
    DateTime? timeIsUp,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      fileUrls: fileUrls ?? this.fileUrls,
      timeCreated: timeCreated ?? this.timeCreated,
      timeIsUp: timeIsUp ?? this.timeIsUp,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'fileUrls': fileUrls,
      'timeCreated': timeCreated,
      'timeIsUp': timeIsUp,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      timeIsUp: (json['timeIsUp'] as Timestamp).toDate(),
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      title: json['title'] as String?,
      fileUrls: (json['fileUrls'] as List?)?.map((e) => e as String).toList(),
    );
  }

  @override
  List<Object> get props => [id!, timeCreated];
}
