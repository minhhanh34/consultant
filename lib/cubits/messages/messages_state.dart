import 'package:consultant/models/message.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageFatched extends MessageState {
  final List<Message> messages;
  MessageFatched(this.messages);
}