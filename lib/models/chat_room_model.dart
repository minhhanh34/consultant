// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChatRoom extends Equatable {
  final String? id;
  final String firstPersonId;
  final String secondPersonId;
  const ChatRoom({
    this.id,
    required this.firstPersonId,
    required this.secondPersonId,
  });

  ChatRoom copyWith({
    String? id,
    String? firstPersonId,
    String? secondPersonId,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      firstPersonId: firstPersonId ?? this.firstPersonId,
      secondPersonId: secondPersonId ?? this.secondPersonId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'firstPersonId': firstPersonId,
      'secondPersonId': secondPersonId,
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      firstPersonId: json['firstPersonId'] as String,
      secondPersonId: json['secondPersonId'] as String,
    );
  }

  @override
  List<Object> get props => [firstPersonId, secondPersonId, id!];
}
