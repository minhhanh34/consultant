// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Comment extends Equatable {
  final String? id;
  final String commentatorName;
  final String commentatorAvatar;
  final DateTime time;
  final double rate;
  final String content;
  const Comment({
    this.id,
    required this.commentatorName,
    required this.commentatorAvatar,
    required this.time,
    required this.rate,
    required this.content,
  });

  @override
  List<Object> get props {
    return [
      commentatorName,
      commentatorAvatar,
      time,
      rate,
      content,
    ];
  }

  Comment copyWith({
    String? id,
    String? commentatorName,
    String? commentatorAvatar,
    DateTime? time,
    double? rate,
    String? content,
  }) {
    return Comment(
      id: id ?? this.id,
      commentatorName: commentatorName ?? this.commentatorName,
      commentatorAvatar: commentatorAvatar ?? this.commentatorAvatar,
      time: time ?? this.time,
      rate: rate ?? this.rate,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'commentatorName': commentatorName,
      'commentatorAvatar': commentatorAvatar,
      'time': time,
      'rate': rate,
      'content': content,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentatorName: json['commentatorName'] as String,
      commentatorAvatar: json['commentatorAvatar'] as String,
      time: (json['time'] as Timestamp).toDate(),
      rate: json['rate'] as double,
      content: json['content'] as String,
    );
  }
}
