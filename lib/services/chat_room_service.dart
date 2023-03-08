import 'package:consultant/models/chat_room.dart';
import 'package:consultant/repositories/chat_room_repository.dart';

class ChatRoomService {
  final ChatRoomRepository _chatRoomRepository;
  ChatRoomService(this._chatRoomRepository);

  Future<ChatRoom> createChatRoom(ChatRoom room) async {
    return await _chatRoomRepository.create(room);
  } 
}