// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:consultant/models/message_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChatRoom extends Equatable {
  final String? id;
  final String firstPersonId;
  final String secondPersonId;
  final Message? lastMessage;
  const ChatRoom({
    this.id,
    required this.firstPersonId,
    required this.secondPersonId,
    this.lastMessage,
  });

  ChatRoom copyWith({
    String? id,
    String? firstPersonId,
    String? secondPersonId,
    Message? lastMessage,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      firstPersonId: firstPersonId ?? this.firstPersonId,
      secondPersonId: secondPersonId ?? this.secondPersonId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'firstPersonId': firstPersonId,
      'secondPersonId': secondPersonId,
      'lastMessage': lastMessage?.toJson(),
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      firstPersonId: json['firstPersonId'] as String,
      secondPersonId: json['secondPersonId'] as String,
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(
              json['lastMessage'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  List<Object> get props => [firstPersonId, secondPersonId, id!];
}
