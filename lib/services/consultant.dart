import 'package:consultant/models/comment.dart';
import 'package:consultant/repositories/comment_repository.dart';
import 'package:consultant/repositories/consultant_repository.dart';

import '../models/consultant.dart';

class ConsultantService {

  final ConsultantRepository _repository;
  final CommentRepository _commentRepository;

  ConsultantService(this._repository, this._commentRepository);

  Future<List<Consultant>> getConsultants() async {
    return await _repository.list();
  }

  Future<List<Comment>> getComments(String id) async {
    final cmts = await _commentRepository.list(id);
    
    return cmts;
  }
}