import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/repositories/chat_repository.dart';
import 'package:consultant/repositories/message_repository.dart';

import '../models/message_model.dart';

class ChatService {
  final ChatRepository _repository;
  final MessageRepository _messageRepository;
  ChatService(this._repository, this._messageRepository);

  Future<Message> createMessage(String id, Message message) async {
    final snap = await _messageRepository.collection.doc(id).get();
    if (snap.exists) {
      final newMessage = await _repository.create(id, message);
      _messageRepository.update(
        id,
        ChatRoom.fromJson(snap.data() as Map<String, dynamic>)
            .copyWith(id: snap.id, lastMessage: newMessage),
      );
      return newMessage;
    } else {
      final room = await _messageRepository.create(
        ChatRoom(
          firstPersonId: message.senderId,
          secondPersonId: message.receiverId,
        ),
      );
      return await _repository.create(room.id!, message);
    }
  }

  Stream<List<Message>> fetchMessages(ChatRoom room) async* {
    final stream = _repository.collection
        .doc(room.id)
        .collection(_repository.subCollection)
        .orderBy('time', descending: true)
        .snapshots();

    await for (var docs in stream) {
      yield docs.docs
          .map((doc) => Message.fromJson(doc.data()).copyWith(id: doc.id))
          .toList();
    }
  }

  Future<bool> recallMessage(
    String roomId,
    String messageId,
    Message message,
  ) async {
    return await _repository.update(roomId, messageId, message);
  }
}
