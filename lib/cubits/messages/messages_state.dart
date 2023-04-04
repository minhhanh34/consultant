import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/models/consultant_model.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageRooms extends MessageState {
  final List<ChatRoom> rooms;
  final List<Consultant> consultants;
  MessageRooms(this.rooms, this.consultants);
}
