import 'dart:io';

import 'package:consultant/cubits/student_class/student_class_state.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/downloader_service.dart';

class StudentClassCubit extends Cubit<StudentClassState> {
  StudentClassCubit(this._service) : super(StudentClassInitlal());
  final ClassService _service;
  List<Exercise>? _exercises;
  final downloader = DownloaderService.instance;

  Future<void> fetchExercises(String id) async {
    emit(StudentClassLoading());
    _exercises ??= await _service.fetchExercise(id);
    emit(StudentClassExerciseFetched(_exercises!));
  }

  Future<void> downloadFileAttach(FileName fileName) async {
    changeStateForFileName(fileName, DownloadState.downloading);
    emit(StudentClassExerciseFetched(_exercises!));
    await downloader.download(fileName);
    changeStateForFileName(fileName, DownloadState.downloaded);
    emit(StudentClassExerciseFetched(_exercises!));
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

  void openFile(String path) => emit(StudentClassOpenFile(path));

  Future<bool> existInLocal(String path) async {
    return await File(path).exists();
  }
}
