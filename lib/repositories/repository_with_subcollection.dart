import 'package:consultant/utils/libs_for_main.dart';

abstract class RepositoryWithSubCollection<T> {
  Future<T> create(String id, T item);
  Future<List<T>> list(String id);
  Future<T> getOne(String id, String subId);
  Future<bool> update(String id, String subId, T item);
  Future<bool> delete(String id, String subId);
  CollectionReference get collection;
  String get subCollectionName;
}