import 'dart:async';

import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/parent_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_room_model.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
    this._service,
    this._consultantService,
    this._parentService,
  ) : super(ChatInitial());
  final ChatService _service;
  final ConsultantService _consultantService;
  final ParentService _parentService;
  StreamSubscription<List<Message>>? _subscription;

  void openRoom(ChatRoom room) async {}

  void fetchParentMessages(ChatRoom room, String partnerId) async {
    emit(ChatLoading());
    final partner = await _consultantService.get(partnerId);
    _subscription =
        _service.fetchMessages(room).listen((List<Message> messages) {
      emit(ChatParentFetched(partner, messages));
    });
  }

  void fetchConsultantMessages(ChatRoom room, String partnerId) async {
    emit(ChatLoading());
    final partner = await _parentService.get(partnerId);
    _subscription =
        _service.fetchMessages(room).listen((List<Message> messages) {
      emit(ChatConsultantFetched(partner, messages));
    });
  }

  // void initialize() => emit(ChatInitial());
  // TODO fix recall (rooms stream)
  Future<bool> recallMessage(
    String roomId,
    String messageId,
    Message message,
  ) async {
    return await _service.recallMessage(roomId, messageId, message);
  }

  Future<void> streamCancel() async {
    await _subscription?.cancel();
  }

  Future<Message> createMessage(String id, Message message) async {
    return await _service.createMessage(id, message);
  }

  void dispose() {
    _subscription = null;
    emit(ChatInitial());
  }
}
