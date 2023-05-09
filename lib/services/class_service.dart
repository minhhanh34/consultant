import 'dart:developer';
import 'dart:io';

import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/repositories/repository_interface.dart';
import 'package:consultant/repositories/repository_with_subcollection.dart';
import 'package:consultant/services/downloader_service.dart';
import 'package:consultant/services/firebase_storage_service.dart';
import 'package:consultant/utils/libs_for_main.dart';
import 'package:path_provider/path_provider.dart';

import '../models/lesson.dart';

abstract class ClassService {
  Future<Class> create(Class item);
  Future<bool> delete(String id);
  Future<Class?> getOne(String id);
  Future<List<Class>> list();
  Future<bool> update(String id, Class item);
  Future<List<Class>> fetchClasses(String id);
  Future<Student> addStudentToClass(String id, Student student);
  Future<List<Exercise>> fetchExercise(String id);
  Future<List<Submission>> listSubmissions(String classId);
  Future<DownloadState> checkExist(Directory? dir, FileName fileName);
  Future<Exercise> createExercise(String id, Exercise exercise);
  Future<bool> deleteExcercise(String classId, Exercise exercise);
  Future<List<Student>> fetchStudents(String classId);
  Future<bool> enroll(String id, Student student);
  Future<bool> deleteStudent(String id, String studentId);
  Future deleteExerciseCollection(String classId);
  Future deleteStudentCollection(String classId);
  Future<List<Submission>> fetchSubmissions(String classId, String excerciseId);
  Future<List<Submission>> fetchStudentSubmissions(
    String classId,
    String studentId,
  );
  Future<bool> updateSubmission(
    String classId,
    String submissionId,
    Submission submission,
  );
  Future<Submission> createSubmission(String classId, Submission submission);
  Future<List<Class?>> fetchClassesForStudent(Student student);
  Future<Lesson> createLesson(Lesson lesson);
  Future<List<Lesson>> fetchLessons(String classId);
  Future<bool> deleteLesson(String id);
  Future<bool> updateLesson(String id, Lesson newLesson);
  Future<Comment?> fetchComment(String classId);
}

class ClassServiceIml extends ClassService {
  final Repository<Class> _repository;
  final RepositoryWithSubCollection<Student> _classStudentRepository;
  final RepositoryWithSubCollection<Exercise> _classExerciseRepository;
  final RepositoryWithSubCollection<Submission> _classSubmissionRepository;
  final Repository<Lesson> _lessonRepository;
  final CommentRepository _commentRepository;
  ClassServiceIml(
    this._repository,
    this._classStudentRepository,
    this._classExerciseRepository,
    this._classSubmissionRepository,
    this._lessonRepository,
    this._commentRepository,
  );
  @override
  Future<Class> create(Class item) async {
    return await _repository.create(item);
  }

  @override
  Future<bool> delete(String id) async {
    return await _repository.delete(id);
  }

  @override
  Future<Class?> getOne(String id) async {
    return await _repository.getOne(id);
  }

  @override
  Future<List<Class>> list() async {
    return await _repository.list();
  }

  @override
  Future<bool> update(String id, Class item) async {
    return await _repository.update(id, item);
  }

  @override
  Future<List<Class>> fetchClasses(String id) async {
    final querySnaps =
        await _repository.collection.where('consultantId', isEqualTo: id).get();
    return querySnaps.docs.map((doc) {
      return Class.fromJson(
        doc.data() as Map<String, dynamic>,
      ).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<Student> addStudentToClass(String id, Student student) async {
    return await _classStudentRepository.create(id, student);
  }

  @override
  Future<List<Exercise>> fetchExercise(String id) async {
    final dir = await getExternalStorageDirectory();
    final exercies = await _classExerciseRepository.list(id);

    final finalExercises = <Exercise>[];

    for (var exercise in exercies) {
      final fileNames = exercise.fileNames;
      List<FileName> fileNamesTmp = [];
      for (var fileName in fileNames!) {
        final state = await checkExist(dir, fileName);
        fileName = fileName.copyWith(state: state);
        fileNamesTmp.add(fileName);
      }
      exercise = exercise.copyWith(fileNames: fileNamesTmp);
      finalExercises.add(exercise);
    }

    return finalExercises;
  }

  @override
  Future<List<Submission>> listSubmissions(String classId) async {
    return await _classSubmissionRepository.list(classId);
  }

  @override
  Future<DownloadState> checkExist(Directory? dir, FileName fileName) async {
    bool isExist = await File('${dir!.path}/${fileName.name}').exists();
    if (isExist) return DownloadState.downloaded;
    return DownloadState.unDownload;
  }

  @override
  Future<Exercise> createExercise(String id, Exercise exercise) async {
    return await _classExerciseRepository.create(id, exercise);
  }

  @override
  Future<bool> deleteExcercise(String classId, Exercise exercise) async {
    final storage = FirebaseStorageServiceIml();
    if (exercise.fileNames != null && exercise.fileNames!.isNotEmpty) {
      await storage
          .deleteFiles(exercise.fileNames!.map((e) => e.storageName).toList());
    }
    return await _classExerciseRepository.delete(classId, exercise.id!);
  }

  @override
  Future<List<Student>> fetchStudents(String classId) async {
    return await _classStudentRepository.list(classId);
  }

  @override
  Future<bool> enroll(String id, Student student) async {
    try {
      final snap = await _repository.collection.doc(id).get();
      if (!snap.exists) {
        return false;
      }
      await _classStudentRepository.create(id, student);
      return true;
    } catch (e) {
      log('error', error: e);
      return false;
    }
  }

  @override
  Future<bool> deleteStudent(String id, String studentId) async {
    return await _classStudentRepository
        .delete(id, studentId)
        .catchError((e) => false);
  }

  @override
  Future deleteExerciseCollection(String classId) async {
    final snaps = await _classExerciseRepository.collection
        .doc(classId)
        .collection(_classExerciseRepository.subCollectionName)
        .get();
    for (var doc in snaps.docs) {
      await deleteExcercise(
        classId,
        Exercise.fromJson(doc.data()).copyWith(id: doc.id),
      );
    }
  }

  @override
  Future deleteStudentCollection(String classId) async {
    final snaps = await _classStudentRepository.collection
        .doc(classId)
        .collection(_classStudentRepository.subCollectionName)
        .get();
    for (var doc in snaps.docs) {
      await deleteStudent(classId, doc.id);
    }
  }

  @override
  Future<List<Submission>> fetchSubmissions(
      String classId, String excerciseId) async {
    try {
      final snaps = await _classSubmissionRepository.collection
          .doc(classId)
          .collection(_classExerciseRepository.subCollectionName)
          .where('exerciseId', isEqualTo: excerciseId)
          .get();
      // print(snaps.docs.first.data());
      return snaps.docs
          .map((doc) => Submission.fromJson(doc.data()).copyWith(id: doc.id))
          .toList();
    } catch (e) {
      log('error', error: e);
      return [];
    }
  }

  @override
  Future<List<Submission>> fetchStudentSubmissions(
      String classId, String studentId) async {
    final snaps = await _classSubmissionRepository.collection
        .doc(classId)
        .collection(_classSubmissionRepository.subCollectionName)
        .where('studentId', isEqualTo: studentId)
        .get();
    return snaps.docs
        .map((doc) => Submission.fromJson(doc.data()).copyWith(id: doc.id))
        .toList();
  }

  @override
  Future<bool> updateSubmission(
    String classId,
    String submissionId,
    Submission submission,
  ) async {
    return await _classSubmissionRepository
        .update(
          classId,
          submissionId,
          submission,
        )
        .catchError((e) => false);
  }

  @override
  Future<Submission> createSubmission(
    String classId,
    Submission submission,
  ) async {
    return await _classSubmissionRepository.create(classId, submission);
  }

  @override
  Future<List<Class?>> fetchClassesForStudent(Student student) async {
    List<Class?> classes = [];
    for (var classId in student.classIds) {
      classes.add(await _repository.getOne(classId));
    }
    return classes;
  }

  @override
  Future<Lesson> createLesson(Lesson lesson) async {
    return await _lessonRepository.create(lesson);
  }

  @override
  Future<List<Lesson>> fetchLessons(String classId) async {
    final snaps = await _lessonRepository.collection
        .where('classId', isEqualTo: classId)
        .get();
    return snaps.docs
        .map((doc) => Lesson.fromJson(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id))
        .toList();
  }

  @override
  Future<bool> deleteLesson(String id) async {
    return await _lessonRepository.delete(id);
  }

  @override
  Future<bool> updateLesson(String id, Lesson newLesson) async {
    return _lessonRepository.update(id, newLesson);
  }

  @override
  Future<Comment?> fetchComment(String classId) async {
    final classroom = await _repository.getOne(classId);
    if (classroom != null) {
      final parentId = classroom.parentId;
      final comments = await _commentRepository.list(classroom.consultantId);
      Comment? comment;
      for (var com in comments) {
        if (com.parentId == parentId) {
          comment = com;
          return comment;
        }
      }
    }
    return null;
  }
}
