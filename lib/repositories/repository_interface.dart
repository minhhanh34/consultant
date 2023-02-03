abstract class Repository<T> {
  Future<List<T>> list();
  Future<T> getOne(String id);
  Future<T> create(T item);
  Future<bool> update(String id, T item);
  Future<bool> delete(String id);
}