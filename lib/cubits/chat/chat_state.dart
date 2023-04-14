import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/models/message_model.dart';
import 'package:consultant/models/parent_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatParentFetched extends ChatState {
  Consultant partner;
  List<Message> messages;
  ChatParentFetched(this.partner, this.messages);
}

class ChatConsultantFetched extends ChatState {
  Parent partner;
  List<Message> messages;
  ChatConsultantFetched(this.partner, this.messages);
}
