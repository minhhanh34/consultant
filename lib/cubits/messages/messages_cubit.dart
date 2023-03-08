import 'package:consultant/models/consultant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/message_service.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(this._service) : super(MessageInitial());
  final MessageService _service;

  Future<void> sendMessage(String message, Consultant receiver) async {}
}
