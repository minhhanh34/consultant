import 'package:consultant/repositories/repository_interface.dart';

import '../models/lesson.dart';

abstract class LessonService {
  Future<List<Lesson>> fetchLessonsByClassId(String classId);
  Future<Lesson> createLesson(Lesson lesson);
  Future<bool> deleteLesson(String id);
  Future<bool> updateLesson(String id, Lesson newLesson);
}

class LessonServiceIml extends LessonService{
  final Repository<Lesson> _repository;
  LessonServiceIml(this._repository);

  @override
  Future<List<Lesson>> fetchLessonsByClassId(String classId) async {
    final snaps = await _repository.collection
        .orderBy('begin', descending: true)
        .where('classId', isEqualTo: classId)
        .get();
    return snaps.docs.map((snap) {
      return Lesson.fromJson(snap.data() as Map<String, dynamic>)
          .copyWith(id: snap.id);
    }).toList();
  }

  @override
  Future<Lesson> createLesson(Lesson lesson) async {
    return _repository.create(lesson);
  }

  @override
  Future<bool> deleteLesson(String id) async {
    return await _repository.delete(id);
  }

  @override
  Future<bool> updateLesson(String id, Lesson newLesson) async {
    return await _repository.update(id, newLesson);
  }
}
