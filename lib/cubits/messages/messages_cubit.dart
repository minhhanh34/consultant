import 'dart:async';

import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/message_service.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(this._service, this._consultantService)
      : super(MessageInitial());
  final MessageService _service;
  final ConsultantService _consultantService;
  List<ChatRoom>? _rooms;
  // List<Consultant>? _consultants;

  void initialize() => emit(MessageInitial());

  Future<void> fetchRooms(String id) async {
    emit(MessageLoading());
    _rooms ??= await _service.getRecentlyChatRoom(id);
    final consultants = <Consultant>[];
    for (var room in _rooms!) {
      final partnerId = room.firstPersonId == AuthCubit.currentUserId
          ? room.secondPersonId
          : room.firstPersonId;
      final consultant = await _consultantService.get(partnerId);
      consultants.add(consultant);
    }
    emit(MessageRooms(_rooms!, consultants));
  }

  Future<ChatRoom> createChatRoom(ChatRoom room) async {
    return await _service.createRoom(room);
  }

  Future<ChatRoom> checkRoom(ChatRoom room) async {
    return await _service.checkRoom(room);
  }

  void refresh() async {
    _rooms = null;
    await fetchRooms(AuthCubit.currentUserId);
  }

  void dispose() {
    _rooms = null;
    emit(MessageInitial());
  }
}
