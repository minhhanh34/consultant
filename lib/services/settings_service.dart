import 'package:consultant/models/parent.dart';
import 'package:consultant/repositories/settings_repository.dart';

class SettingsService {
  final SettingsRepository _repository;
  SettingsService(this._repository);

  Future<Parent> create(Parent parent) async {
    return await _repository.create(parent);
  }

  Future<Parent> fetchParent(String id) async {
    return await _repository.getOne(id); 
  }
}