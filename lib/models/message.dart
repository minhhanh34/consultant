// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Message extends Equatable {
  final String? id;
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime time;
  final bool seen;
  const Message({
    this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.time,
    required this.seen,
  });

  @override
  List<Object> get props {
    return [
      content,
      senderId,
      receiverId,
      time,
      seen,
    ];
  }

  Message copyWith({
    String? id,
    String? content,
    String? senderId,
    String? receiverId,
    DateTime? time,
    bool? seen,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      time: time ?? this.time,
      seen: seen ?? this.seen,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'time': time,
      'seen': seen,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      time: (json['time'] as Timestamp).toDate(),
      seen: json['seen'] as bool,
    );
  }
}
