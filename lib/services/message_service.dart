import 'package:consultant/models/chat_room.dart';
import 'package:consultant/models/message.dart';

import '../repositories/message_repository.dart';

class MessageService {
  final MessageRepository _repository;
  MessageService(this._repository);

  Future<Message> createMessage(String id, Message message) async {
    return await _repository.create(id, message);
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
