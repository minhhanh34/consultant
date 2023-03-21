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
    final snap = await _repository.collection.doc(room.id).get();
    if (snap.exists) {
      return ChatRoom.fromJson(snap.data() as Map<String, dynamic>)
          .copyWith(id: snap.id);
    }
    final newRoom = await createRoom(room);
    return newRoom;
  }
}
