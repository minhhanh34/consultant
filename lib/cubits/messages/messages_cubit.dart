import 'package:consultant/models/chat_room.dart';
import 'package:consultant/models/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/message_service.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(this._service) : super(MessageInitial());
  final MessageService _service;

  Future<Message> createMessage(String id, Message message) async {
    return await _service.createMessage(id, message);
  }

  void fetchMessages(ChatRoom room) {
    emit(MessageFatched([]));
    _service.fetchMessages(room).listen((List<Message> messages) {
      emit(MessageFatched(messages));
    });
  }

  Future<bool> recallMessage(
    String roomId,
    String messageId,
    Message message,
  ) async {
    return await _service.recallMessage(roomId, messageId, message);
  }
}
