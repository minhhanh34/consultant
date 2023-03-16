// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';

@immutable
class Post extends Equatable {
  final String? id;
  final String content;
  final DateTime time;
  final String posterId;
  final String posterAvtPath;
  final int contacts;
  final String posterName;
  const Post({
    this.id,
    required this.content,
    required this.time,
    required this.posterId,
    required this.posterAvtPath,
    this.contacts = 0,
    required this.posterName,
  });

  Post copyWith({
    String? id,
    String? content,
    DateTime? time,
    String? posterId,
    String? posterAvtPath,
    int? contacts,
    String? posterName,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      time: time ?? this.time,
      posterId: posterId ?? this.posterId,
      posterAvtPath: posterAvtPath ?? this.posterAvtPath,
      contacts: contacts ?? this.contacts,
      posterName: posterName ?? this.posterName,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'content': content,
      'time': time.millisecondsSinceEpoch,
      'posterId': posterId,
      'posterAvtPath': posterAvtPath,
      'contacts': contacts,
      'posterName': posterName,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] as int),
      posterId: json['posterId'] as String,
      posterAvtPath: json['posterAvtPath'] as String,
      contacts: json['contacts'] as int,
      posterName: json['posterName'] as String,
    );
  }

  @override
  List<Object> get props {
    return [
      content,
      time,
      posterId,
      posterAvtPath,
      contacts,
      posterName,
    ];
  }
}
