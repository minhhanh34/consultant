import 'package:consultant/models/comment_model.dart';
import 'package:consultant/repositories/comment_repository.dart';
import 'package:consultant/repositories/consultant_repository.dart';

import '../models/consultant_model.dart';

class ConsultantService {
  final ConsultantRepository _repository;
  final CommentRepository _commentRepository;

  ConsultantService(this._repository, this._commentRepository);

  Future<List<Consultant>> getConsultants() async {
    return await _repository.list();
  }

  Future<List<Consultant>> getPopularConsultants() async {
    final docSnaps = await _repository.collection.limit(4).get();
    return docSnaps.docs.map((docSnap) {
      return Consultant.fromJson(docSnap.data() as Map<String, dynamic>)
          .copyWith(id: docSnap.id);
    }).toList();
  }

  Future<List<Comment>> getComments(String id) async {
    final cmts = await _commentRepository.list(id);
    return cmts;
  }

  Future<List<Consultant>> applyFilter(List<String> filter) async {
    filter = filter.map((element) => element.toLowerCase()).toList();
    final consultants = await _repository.list();
    final filteredConsultants = consultants.where((consultant) {
      for (var sub in consultant.subjects) {
        if (filter.every((element) =>
            element.toLowerCase().contains(sub.name.toLowerCase()))) {
          return true;
        }
      }
      return false;
    }).toList();
    return filteredConsultants;
  }

  Future<Consultant> get(String id) async {
    return await _repository.getOne(id);
  }
}
