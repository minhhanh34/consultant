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
  final String parentId;
  const Comment({
    this.id,
    required this.commentatorName,
    required this.commentatorAvatar,
    required this.time,
    required this.rate,
    required this.content,
    required this.parentId,
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
    String? parentId,
  }) {
    return Comment(
      id: id ?? this.id,
      commentatorName: commentatorName ?? this.commentatorName,
      commentatorAvatar: commentatorAvatar ?? this.commentatorAvatar,
      time: time ?? this.time,
      rate: rate ?? this.rate,
      content: content ?? this.content,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'commentatorName': commentatorName,
      'commentatorAvatar': commentatorAvatar,
      'time': time,
      'rate': rate,
      'content': content,
      'parentId': parentId,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      parentId: json['parentId'],
      commentatorName: json['commentatorName'] as String,
      commentatorAvatar: json['commentatorAvatar'] as String,
      time: (json['time'] as Timestamp).toDate(),
      rate: json['rate'] as double,
      content: json['content'] as String,
    );
  }
}
