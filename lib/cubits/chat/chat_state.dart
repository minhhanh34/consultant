import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatFetched extends ChatState {
  Consultant partner;
  List<Message> messages;
  ChatFetched(this.partner, this.messages);
}
