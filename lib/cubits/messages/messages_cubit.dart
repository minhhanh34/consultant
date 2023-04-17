import 'dart:async';

import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/parent_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/parent_model.dart';
import '../../services/message_service.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(this._service, this._consultantService, this._parentService)
      : super(MessageInitial());
  final MessageService _service;
  final ConsultantService _consultantService;
  final ParentService _parentService;
  StreamSubscription<List<ChatRoom>>? _roomStream;

  void initialize() => emit(MessageInitial());

  Future<void> fetchParentRooms(String id) async {
    emit(MessageLoading());
    _roomStream = _service.getRecentlyChatRoom(id).listen((rooms) async {
      final consultants = <Consultant>[];
      for (var room in rooms) {
        final partnerId = room.firstPersonId == AuthCubit.currentUserId
            ? room.secondPersonId
            : room.firstPersonId;
        final consultant = await _consultantService.get(partnerId);
        consultants.add(consultant);
      }
      emit(MessageParentRooms(rooms, consultants));
    });
    // if (_roomStream != null) {
    //   _roomStream!.
    // }

    // await for (var rooms in _roomStream!) {
    //   for (var room in rooms) {
    //     final partnerId = room.firstPersonId == AuthCubit.currentUserId
    //         ? room.secondPersonId
    //         : room.firstPersonId;
    //     final consultant = await _consultantService.get(partnerId);
    //     consultants.add(consultant);
    //   }
    //   emit(MessageParentRooms(rooms, consultants));
    // }
  }

  // Future<void> refresh() async {
  //   if (state is MessageConsultantRooms) {
  //     _roomStream = null;
  //     fetchConsultantRooms(AuthCubit.currentUserId!);
  //   } else {
  //     _roomStream = null;
  //     fetchParentRooms(AuthCubit.currentUserId!);
  //   }
  // }

  Future<void> fetchConsultantRooms(String id) async {
    emit(MessageLoading());
    _roomStream = _service.getRecentlyChatRoom(id).listen((rooms) async {
      final parents = <Parent>[];
      for (var room in rooms) {
        final partnerId = room.firstPersonId == AuthCubit.currentUserId
            ? room.secondPersonId
            : room.firstPersonId;
        final parent = await _parentService.get(partnerId);
        parents.add(parent);
      }
      emit(MessageConsultantRooms(rooms, parents));
    });

    // if (_roomStream != null) {
    //   _roomStream!.
    // }

    // await for (var rooms in _roomStream!) {
    //   for (var room in rooms) {
    //     final partnerId = room.firstPersonId == AuthCubit.currentUserId
    //         ? room.secondPersonId
    //         : room.firstPersonId;
    //     final parent = await _parentService.get(partnerId);
    //     parents.add(parent);
    //   }
    //   emit(MessageConsultantRooms(rooms, parents));
    // }
  }

  Future<ChatRoom> createChatRoom(ChatRoom room) async {
    return await _service.createRoom(room);
  }

  Future<ChatRoom> checkRoom(BuildContext context, ChatRoom room) async {
    return await _service.checkRoom(context, room);
  }

  Future<void> refresh() async {
    _roomStream = null;
    String id = AuthCubit.currentUserId!;
    if (AuthCubit.userType?.toLowerCase() == 'consultant') {
      await fetchConsultantRooms(id);
    } else if (AuthCubit.userType?.toLowerCase() == 'parent') {
      await fetchParentRooms(id);
    }
  }

  // void addRoomCached(ChatRoom room) {
  //   _roomStream?.add(room);
  // }

  void dispose() {
    _roomStream?.cancel();
    _roomStream = null;
    emit(MessageInitial());
  }
}
