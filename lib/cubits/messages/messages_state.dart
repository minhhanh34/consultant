import 'package:consultant/models/chat_room_model.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageRooms extends MessageState {
  final List<ChatRoom> rooms;
  MessageRooms(this.rooms);
}
