import 'dart:async';

import 'package:consultant/models/chat_room_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/message_service.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(this._service) : super(MessageInitial());
  final MessageService  _service;
  List<ChatRoom>? rooms;

  void initialize() => emit(MessageInitial());

  Future<void> fetchRooms(String id) async {
    emit(MessageLoading());
    rooms ??= await _service.getRecentlyChatRoom(id);
    emit(MessageRooms(rooms!));
  }

  Future<ChatRoom> createChatRoom(ChatRoom room) async {
    return await _service.createRoom(room);
  }

  Future<ChatRoom> checkRoom(ChatRoom room) async {
    return await _service.checkRoom(room);
  }
}
