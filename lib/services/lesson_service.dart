import 'package:consultant/repositories/lesson_repository.dart';

import '../models/lesson.dart';

class LessonService {
  final LessonRepository _repository;
  LessonService(this._repository);

  Future<List<Lesson>> fetchLessonsByClassId(String classId) async {
    final snaps =
        await _repository.collection.where('classId', isEqualTo: classId).get();
    return snaps.docs.map((snap) {
      return Lesson.fromJson(snap.data() as Map<String, dynamic>)
          .copyWith(id: snap.id);
    }).toList();
  }

  Future<bool> updateLesson(String id, Lesson lesson) async {
    return await _repository.update(id, lesson);
  }

  Future<Lesson> createLesson(Lesson lesson) async {
    return _repository.create(lesson);
  }
}
