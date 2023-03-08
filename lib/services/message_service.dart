import '../repositories/message_repository.dart';

class MessageService {
  final MessageRepository _repository;
  MessageService(this._repository);
}