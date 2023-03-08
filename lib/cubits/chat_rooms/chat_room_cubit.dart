import 'package:consultant/cubits/chat_rooms/chat_room_state.dart';
import 'package:consultant/models/chat_room.dart';
import 'package:consultant/services/chat_room_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  ChatRoomCubit(this._service) : super(ChatRoomInitial());
  final ChatRoomService _service;

  Future<ChatRoom> createChatRoom(ChatRoom room) async {
    return await _service.createChatRoom(room);
  }
}
