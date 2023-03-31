import 'dart:async';

import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_room_model.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._service, this._consultantService) : super(ChatInitial());
  final ChatService _service;
  final ConsultantService _consultantService;
  StreamSubscription<List<Message>>? _subscription;
  Consultant? _partner;

  void openRoom(ChatRoom room) async {}

  void fetchMessages(ChatRoom room, String partnerId) async {
    emit(ChatLoading());
    _partner = await _consultantService.get(partnerId);
    _subscription =
        _service.fetchMessages(room).listen((List<Message> messages) {
      emit(ChatFetched(_partner!, messages));
    });
  }

  // void initialize() => emit(ChatInitial());

  Future<bool> recallMessage(
    String roomId,
    String messageId,
    Message message,
  ) async {
    return await _service.recallMessage(roomId, messageId, message);
  }

  Future<void> streamCancel() async {
    await _subscription?.cancel();
    _partner = null;
  }

  Future<Message> createMessage(String id, Message message) async {
    return await _service.createMessage(id, message);
  }

  void dispose() {
    _subscription = null;
    _partner = null;
    emit(ChatInitial());
  }
}
