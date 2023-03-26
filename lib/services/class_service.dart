import 'dart:io';

import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/repositories/class_exercise_subcollection_repository.dart';
import 'package:consultant/repositories/class_repository.dart';
import 'package:consultant/repositories/class_student_subcollection_repository.dart';
import 'package:consultant/services/downloader_service.dart';
import 'package:path_provider/path_provider.dart';

import '../models/class_model.dart';

class ClassService {
  final ClassRepository _repository;
  final ClassStudentRepository _classStudentRepository;
  final ClassExerciseRepository _classExerciseRepository;

  ClassService(
    this._repository,
    this._classStudentRepository,
    this._classExerciseRepository,
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

  Future<DownloadState> checkExist(Directory? dir, FileName fileName) async {
    bool isExist = await File('${dir!.path}/${fileName.name}').exists();
    if (isExist) return DownloadState.downloaded;
    return DownloadState.unDownload;
  }

  Future<Exercise> createExercise(String id, Exercise exercise) async {
    return await _classExerciseRepository.create(id, exercise);
  }

  Future<bool> deleteExcercise(String classId, String exerciseId) async {
    return await _classExerciseRepository.delete(classId, exerciseId);
  }

  Future<List<Student>> fetchStudents(String classId) async {
    return await _classStudentRepository.list(classId);
  }
}