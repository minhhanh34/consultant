import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/repositories/message_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageService {
  final MessageRepository _repository;
  MessageService(this._repository);

  Future<List<ChatRoom>> getRecentlyChatRoom(String id) async {
    final firstPartDocs = await _repository.collection
        .where('firstPersonId', isEqualTo: id)
        .get();
    final secondPartDocs = await _repository.collection
        .where('secondPersonId', isEqualTo: id)
        .get();
    final roomsDocs = [...firstPartDocs.docs, ...secondPartDocs.docs];
    if (roomsDocs.isEmpty) {
      return <ChatRoom>[];
    }
    final rooms = roomsDocs
        .map((doc) => ChatRoom.fromJson(doc.data()! as Map<String, dynamic>)
            .copyWith(id: doc.id))
        .toList();
    return rooms;
  }

  Future<ChatRoom> createRoom(ChatRoom room) async {
    return await _repository.create(room);
  }

  Future<ChatRoom> checkRoom(BuildContext context, ChatRoom room) async {
    final messageCubit = context.read<MessageCubit>();
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
      messageCubit.addRoomCached(room);
      return newRoom;
    }
    final firstFilteredRoom = filteredRooms.first;
    return firstFilteredRoom;
  }
}
