import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/repositories/repository_interface.dart';
import 'package:consultant/repositories/repository_with_subcollection.dart';

import '../models/message_model.dart';

abstract class ChatService {
  Future<Message> createMessage(String id, Message message);
  Stream<List<Message>> fetchMessages(ChatRoom room);
  Future<bool> recallMessage(String roomId, String messageId, Message message);
}

class ChatServiceIml extends ChatService {
  final RepositoryWithSubCollection<Message> _repository;
  final Repository<ChatRoom> _messageRepository;
  ChatServiceIml(this._repository, this._messageRepository);

  @override
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

  @override
  Stream<List<Message>> fetchMessages(ChatRoom room) async* {
    final stream = _repository.collection
        .doc(room.id)
        .collection(_repository.subCollectionName)
        .orderBy('time', descending: true)
        .snapshots();

    await for (var docs in stream) {
      yield docs.docs
          .map((doc) => Message.fromJson(doc.data()).copyWith(id: doc.id))
          .toList();
    }
  }

  @override
  Future<bool> recallMessage(
    String roomId,
    String messageId,
    Message message,
  ) async {
    return await _repository.update(roomId, messageId, message);
  }
}
