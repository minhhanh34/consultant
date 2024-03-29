import 'dart:io';

import 'package:consultant/cubits/consultant_class/class_state.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/models/submission_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/class_model.dart';
import '../../models/lesson.dart';
import '../../models/student_model.dart';
import '../../services/downloader_service.dart';

class ClassCubit extends Cubit<ClassState> {
  ClassCubit(this._service) : super(ClassInitial());
  final ClassService _service;
  final DownloaderService downloader = DownloaderServiceIml.instance;
  List<Class>? _classes;
  List<Exercise>? _exercises;
  List<Student>? _students;
  List<Submission>? _submissions;
  List<Lesson>? _lessons;

  // void fetchClasses(String id) async {
  //   _classes ??= await _service.fetchClasses(id);
  // }

  Future<Class> createClass(Class cla) async {
    emit(ClassLoading());
    final newClass = await _service.create(cla);
    _classes?.add(newClass);
    emit(ClassFethed(_classes!));
    return newClass;
  }

  Future<void> createExercise(String id, Exercise exercise) async {
    final newExc = await _service.createExercise(id, exercise);
    _exercises?.insert(0, newExc);
    emit(ClassDetailFethed(
      exercises: _exercises!,
      students: _students!,
      submissions: _submissions!,
      lessons: _lessons!,
    ));
  }

  void goToClass() => emit(ClassInitial());

  void deleteExcercise(String classId, Exercise exercise) async {
    await _service.deleteExcercise(classId, exercise);
    _exercises?.remove(exercise);
    emit(ClassDetailFethed(
      exercises: _exercises!,
      students: _students!,
      submissions: _submissions!,
      lessons: _lessons!,
    ));
  }

  Future<void> refreshExercises(String classId) async {
    emit(ClassLoading());
    _exercises = null;
    _exercises = await _service.fetchExercise(classId);
    emit(ClassDetailFethed(
        exercises: _exercises!,
        students: _students!,
        submissions: _submissions!,
        lessons: _lessons!));
  }

  void onLoading() => emit(ClassLoading());

  Future<void> downloadFileAttach(FileName fileName) async {
    changeStateForFileName(fileName, DownloadState.downloading);
    emit(ClassDetailFethed(
      exercises: _exercises!,
      students: _students!,
      submissions: _submissions!,
      lessons: _lessons!,
    ));
    await downloader.download(fileName);
    changeStateForFileName(fileName, DownloadState.downloaded);
    emit(ClassDetailFethed(
      exercises: _exercises!,
      students: _students!,
      submissions: _submissions!,
      lessons: _lessons!,
    ));
  }

  void changeStateForFileName(FileName fileName, DownloadState state) {
    final fileNameTmp = fileName.copyWith(state: state);
    final searchExc = _exercises!
        .indexWhere((excercise) => excercise.fileNames!.contains(fileName));
    _exercises![searchExc]
            .fileNames![_exercises![searchExc].fileNames!.indexOf(fileName)] =
        fileNameTmp;
  }

  void onFilePressed(FileName fileName) async {
    final oldState = state;
    if (fileName.state == DownloadState.downloaded) {
      final dir = await getExternalStorageDirectory();
      final path = '${dir!.path}/${fileName.name}';
      openFile(path);
      emit(oldState);
    } else if (fileName.state == DownloadState.unDownload) {
      downloadFileAttach(fileName);
    }
  }

  void openFile(String path) => emit(OpenExerciseAttachFile(path));

  Future<bool> existInLocal(String path) async {
    return await File(path).exists();
  }

  Future<void> fetchDetailClass(String classId) async {
    emit(ClassLoading());
    _exercises = await _service.fetchExercise(classId);
    _students = await _service.fetchStudents(classId);
    _submissions = await _service.listSubmissions(classId);
    _lessons = await _service.fetchLessons(classId);
    emit(ClassDetailFethed(
      exercises: _exercises!,
      students: _students!,
      submissions: _submissions!,
      lessons: _lessons!,
    ));
  }

  Future<void> rejectStudent(String classId, String studentId) async {
    // emit(ClassLoading());
    await _service.deleteStudent(classId, studentId);
    _students?.removeWhere((element) => element.id == studentId);
    // emit(ClassDetailFethed(
    //   exercises: _exercises!,
    //   students: _students!,
    //   submissions: _submissions!,
    // ));
  }

  Future<void> fetchSubmissions(String classId, String exercieId) async {
    emit(ClassLoading());
    _submissions ??= await _service.fetchSubmissions(classId, exercieId);
    emit(ClassSubmissions(_submissions!));
  }

  Future<void> comment(
    String classId,
    String submissionId,
    Submission submission,
  ) async {
    await _service.updateSubmission(classId, submissionId, submission);
  }

  Future<void> createLesson(Lesson lesson) async {
    emit(ClassLoading());
    final newLesson = await _service.createLesson(lesson);
    int firstArrIndex = 0;
    _lessons?.insert(firstArrIndex, newLesson);
    emit(ClassDetailFethed(
      exercises: _exercises!,
      students: _students!,
      submissions: _submissions!,
      lessons: _lessons!,
    ));
  }

  Future<void> deleteLesson(String id) async {
    bool result = await _service.deleteLesson(id);
    if (result) {
      _lessons?.removeWhere((lesson) => lesson.id == id);
      emit(ClassDetailFethed(
        exercises: _exercises!,
        lessons: _lessons!,
        students: _students!,
        submissions: _submissions!,
      ));
    }
  }

  Future<void> updateLesson(String id, Lesson newLesson) async {
    bool result = await _service.updateLesson(id, newLesson);
    if (result) {
      final index = _lessons?.indexWhere((lesson) => lesson.id! == id);
      if (index != null) {
        _lessons?[index] = newLesson;
      }
    }
    emit(ClassDetailFethed(
        exercises: _exercises!,
        students: _students!,
        submissions: _submissions!,
        lessons: _lessons!));
  }

  Future<void> refreshLessosn(String classId) async {
    emit(ClassLoading());
    _lessons = null;
    _lessons = await _service.fetchLessons(classId);
    emit(ClassDetailFethed(
        exercises: _exercises!,
        students: _students!,
        submissions: _submissions!,
        lessons: _lessons!));
  }

  void dispose() {
    _classes = null;
    _exercises = null;
    _students = null;
    _submissions = null;
    _lessons = null;
    emit(ClassInitial());
  }
}
