import 'dart:async';

import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/parent_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/message_service.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(this._service, this._consultantService, this._parentService)
      : super(MessageInitial());
  final MessageService _service;
  final ConsultantService _consultantService;
  final ParentService _parentService;

  List<ChatRoom>? _rooms;

  void initialize() => emit(MessageInitial());

  //TODO fetch rooms for consultant side
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

  Future<ChatRoom> checkRoom(BuildContext context, ChatRoom room) async {
    return await _service.checkRoom(context, room);
  }

  void refresh() async {
    _rooms = null;
    await fetchRooms(AuthCubit.currentUserId!);
  }

  void addRoomCached(ChatRoom room) {
    _rooms?.add(room);
  }

  void dispose() {
    _rooms = null;
    emit(MessageInitial());
  }
}
