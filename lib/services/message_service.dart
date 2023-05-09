import 'dart:async';
import 'package:async/async.dart';

import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/repositories/repository_interface.dart';
import 'package:flutter/material.dart';

abstract class MessageService {
  Stream<List<ChatRoom>> getRecentlyChatRoom(String id);
  Future<ChatRoom> createRoom(ChatRoom room);
  Future<ChatRoom> checkRoom(BuildContext context, ChatRoom room);
}

class MessageServiceIml extends MessageService {
  final Repository<ChatRoom> _repository;
  MessageServiceIml(this._repository);

  @override
  Stream<List<ChatRoom>> getRecentlyChatRoom(String id) {
    final firstPartDocs = _repository.collection
        .where('firstPersonId', isEqualTo: id)
        .snapshots();
    final secondPartDocs = _repository.collection
        .where('secondPersonId', isEqualTo: id)
        .snapshots();

    return StreamZip([firstPartDocs, secondPartDocs]).map((doc) {
      final room1 = doc[0]
          .docs
          .map((e) => ChatRoom.fromJson(e.data() as Map<String, dynamic>)
              .copyWith(id: e.id))
          .toList();
      final room2 = doc[1]
          .docs
          .map((e) => ChatRoom.fromJson(e.data() as Map<String, dynamic>)
              .copyWith(id: e.id))
          .toList();
      return [...room1, ...room2];
    });
  }

  @override
  Future<ChatRoom> createRoom(ChatRoom room) async {
    return await _repository.create(room);
  }

  @override
  Future<ChatRoom> checkRoom(BuildContext context, ChatRoom room) async {
    // final messageCubit = context.read<MessageCubit>();
    final rooms = await _repository.list();
    String roomFirstSecond = '${room.firstPersonId}${room.secondPersonId}';
    final filteredRooms = rooms.where((roomElement) {
      String roomElementFirstSecond =
          '${roomElement.firstPersonId}${roomElement.secondPersonId}';
      String roomElementSecondFirst =
          '${roomElement.secondPersonId}${roomElement.firstPersonId}';
      return (roomFirstSecond == roomElementFirstSecond) ||
          (roomFirstSecond == roomElementSecondFirst);
    }).toList();
    if (filteredRooms.isEmpty) {
      final newRoom = await createRoom(room);
      // messageCubit.addRoomCached(room);
      return newRoom;
    }
    final firstFilteredRoom = filteredRooms.first;
    return firstFilteredRoom;
  }
}
