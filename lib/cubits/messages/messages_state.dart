import 'package:consultant/models/chat_room_model.dart';
import 'package:consultant/models/consultant_model.dart';

import '../../models/parent_model.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageParentRooms extends MessageState {
  final List<ChatRoom> rooms;
  final List<Consultant> consultants;
  MessageParentRooms(this.rooms, this.consultants);
}

class MessageConsultantRooms extends MessageState {
  final List<ChatRoom> rooms;
  final List<Parent> parents;
  MessageConsultantRooms(this.rooms, this.parents);
}
