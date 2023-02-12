import 'package:consultant/repositories/consultant_repository.dart';

import '../models/consultant.dart';

class ConsultantService {

  final ConsultantRepository repository;

  ConsultantService(this.repository);

  Future<List<Consultant>> getConsultants() async {
    return await repository.list();
  }
}