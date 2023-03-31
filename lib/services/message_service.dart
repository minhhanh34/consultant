import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/repositories/message_repository.dart';

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
    final rooms = roomsDocs
        .map((doc) => ChatRoom.fromJson(doc.data()! as Map<String, dynamic>)
            .copyWith(id: doc.id))
        .toList();
    return rooms;
  }

  Future<ChatRoom> createRoom(ChatRoom room) async {
    return await _repository.create(room);
  }

  Future<ChatRoom> checkRoom(ChatRoom room) async {
    // print(room.firstPersonId);
    // print(room.secondPersonId);

    // final first = await _repository.collection.where(
    //   'firstPersonId',
    //   whereIn: [room.firstPersonId, room.secondPersonId],
    // ).get();
    // final second = await _repository.collection.where('secondPersonId',
    //     whereIn: [room.firstPersonId, room.secondPersonId]).get();

    // final firstRooms = first.docs
    //     .map((e) =>
    //         ChatRoom.fromJson(e.data() as Map<String, dynamic>).copyWith(id: e.id))
    //     .toList();
    // final secondRooms = second.docs
    //     .map((e) =>
    //         ChatRoom.fromJson(e.data() as Map<String, dynamic>).copyWith(id: e.id))
    //     .toList();

    // firstRooms.removeWhere((room) => secondRooms.contains(room));

    // if (firstRooms.isNotEmpty && firstRooms.length == 1) {
    //   return ChatRoom.fromJson(first.docs.first.data() as Map<String, dynamic>)
    //       .copyWith(id: first.docs.first.id);
    // }
    // final newRoom = await createRoom(room);
    // return newRoom;
    final snap = await _repository.collection.doc(room.id).get();
    if (snap.exists) {
      return ChatRoom.fromJson(snap.data() as Map<String, dynamic>)
          .copyWith(id: snap.id);
    }
    final newRoom = await createRoom(room);
    return newRoom;
  }
}
