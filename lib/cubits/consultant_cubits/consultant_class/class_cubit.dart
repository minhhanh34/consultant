import 'dart:io';

import 'package:consultant/cubits/consultant_cubits/consultant_class/class_state.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/class_model.dart';
import '../../../models/student_model.dart';
import '../../../services/downloader_service.dart';

class ClassCubit extends Cubit<ClassState> {
  ClassCubit(this._service) : super(ClassInitial());
  final ClassService _service;
  final downloader = DownloaderService.instance;
  List<Class>? _classes;
  List<Exercise>? _exercises;
  List<Student>? _students;

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

  void createExercise(String id, Exercise exercise) async {
    final newExc = await _service.createExercise(id, exercise);
    _exercises?.add(newExc);
    emit(ClassDetailFethed(exercises: _exercises!, students: _students!));
  }

  // void fetchExercises(String id) async {
  //   emit(ClassLoading());
  //   _exercises = await _service.fetchExercise(id);
  //   emit(ClassExerciseFetched(_exercises!));
  // }

  void goToClass() => emit(ClassInitial());

  void deleteExcercise(String classId, Exercise exercise) async {
    await _service.deleteExcercise(classId, exercise.id!);
    _exercises?.remove(exercise);
    emit(ClassDetailFethed(exercises: _exercises!, students: _students!));
  }

  void onLoading() => emit(ClassLoading());

  Future<void> downloadFileAttach(FileName fileName) async {
    changeStateForFileName(fileName, DownloadState.downloading);
    emit(ClassDetailFethed(exercises: _exercises!, students: _students!));
    await downloader.download(fileName);
    changeStateForFileName(fileName, DownloadState.downloaded);
    emit(ClassDetailFethed(exercises: _exercises!, students: _students!));
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

  // void previousState(ClassState oldState) => emit(oldState);

  // Future<void> onRefresh() async {
  //   _classes = null;
  //   fetchClasses('3va8glsR7Gl3suoLE5Wz');
  // }

  // void onMemberTab(String classId) async {
  //   emit(ClassLoading());
  //   _students ??= await _service.fetchStudents(classId);
  //   emit(ClassStudentFetched(_students!));
  // }

  void fetchDetailClass(String classId) async {
    emit(ClassLoading());
    _exercises = await _service.fetchExercise(classId);
    _students = await _service.fetchStudents(classId);
    emit(ClassDetailFethed(exercises: _exercises!, students: _students!));
  }
}
