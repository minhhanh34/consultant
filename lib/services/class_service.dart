import 'dart:developer';
import 'dart:io';

import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/repositories/class_exercise_subcollection_repository.dart';
import 'package:consultant/repositories/class_repository.dart';
import 'package:consultant/repositories/class_student_subcollection_repository.dart';
import 'package:consultant/repositories/class_submission_subcollection_repository.dart';
import 'package:consultant/services/downloader_service.dart';
import 'package:consultant/services/firebase_storage_service.dart';
import 'package:path_provider/path_provider.dart';

import '../models/class_model.dart';
import '../models/submission_model.dart';

class ClassService {
  final ClassRepository _repository;
  final ClassStudentRepository _classStudentRepository;
  final ClassExerciseRepository _classExerciseRepository;
  final ClassSubmissionRepository _classSubmissionRepository;
  ClassService(
    this._repository,
    this._classStudentRepository,
    this._classExerciseRepository,
    this._classSubmissionRepository,
  );
  Future<Class> create(Class item) async {
    return await _repository.create(item);
  }

  Future<bool> delete(String id) async {
    return await _repository.delete(id);
  }

  Future<Class> getOne(String id) async {
    return await _repository.getOne(id);
  }

  Future<List<Class>> list() async {
    return await _repository.list();
  }

  Future<bool> update(String id, Class item) async {
    return await _repository.update(id, item);
  }

  Future<List<Class>> fetchClasses(String id) async {
    final querySnaps =
        await _repository.collection.where('consultantId', isEqualTo: id).get();
    return querySnaps.docs.map((doc) {
      return Class.fromJson(
        doc.data() as Map<String, dynamic>,
      ).copyWith(id: doc.id);
    }).toList();
  }

  Future<Student> addStudentToClass(String id, Student student) async {
    return await _classStudentRepository.create(id, student);
  }

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

  Future<List<Submission>> listSubmissions(String classId) async {
    return await _classSubmissionRepository.list(classId);
  }

  Future<DownloadState> checkExist(Directory? dir, FileName fileName) async {
    bool isExist = await File('${dir!.path}/${fileName.name}').exists();
    if (isExist) return DownloadState.downloaded;
    return DownloadState.unDownload;
  }

  Future<Exercise> createExercise(String id, Exercise exercise) async {
    return await _classExerciseRepository.create(id, exercise);
  }

  Future<bool> deleteExcercise(String classId, Exercise exercise) async {
    final storage = FirebaseStorageService();
    if (exercise.fileNames != null && exercise.fileNames!.isNotEmpty) {
      await storage
          .deleteFiles(exercise.fileNames!.map((e) => e.storageName).toList());
    }
    return await _classExerciseRepository.delete(classId, exercise.id!);
  }

  Future<List<Student>> fetchStudents(String classId) async {
    return await _classStudentRepository.list(classId);
  }

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

  Future<bool> deleteStudent(String id, String studentId) async {
    return await _classStudentRepository
        .delete(id, studentId)
        .catchError((e) => false);
  }

  Future deleteExerciseCollection(String classId) async {
    final snaps = await _classExerciseRepository.collection
        .doc(classId)
        .collection(_classExerciseRepository.subCollection)
        .get();
    for (var doc in snaps.docs) {
      await deleteExcercise(
        classId,
        Exercise.fromJson(doc.data()).copyWith(id: doc.id),
      );
    }
  }

  Future deleteStudentCollection(String classId) async {
    final snaps = await _classStudentRepository.collection
        .doc(classId)
        .collection(_classStudentRepository.subCollection)
        .get();
    for (var doc in snaps.docs) {
      await deleteStudent(classId, doc.id);
    }
  }

  Future<List<Submission>> fetchSubmissions(
      String classId, String excerciseId) async {
    try {
      final snaps = await _classSubmissionRepository.collection
          .doc(classId)
          .collection(_classExerciseRepository.subCollection)
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

  Future<List<Submission>> fetchStudentSubmissions(
      String classId, String studentId) async {
    final snaps = await _classSubmissionRepository.collection
        .doc(classId)
        .collection(_classSubmissionRepository.subCollection)
        .where('studentId', isEqualTo: studentId)
        .get();
    return snaps.docs
        .map((doc) => Submission.fromJson(doc.data()).copyWith(id: doc.id))
        .toList();
  }

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

  Future<Submission> createSubmission(
    String classId,
    Submission submission,
  ) async {
    return await _classSubmissionRepository.create(classId, submission);
  }

  Future<List<Class>> fetchClassesForStudent(Student student) async {
    List<Class> classes = [];
    for (var classId in student.classIds) {
      classes.add(await _repository.getOne(classId));
    }
    return classes;
  }
}
