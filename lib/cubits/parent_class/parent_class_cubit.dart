import 'package:consultant/models/comment_model.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:consultant/services/parent_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/lesson.dart';
import '../../models/submission_model.dart';
import '../../services/downloader_service.dart';
import 'parent_class_state.dart';

class ParentClassCubit extends Cubit<ParentClassState> {
  ParentClassCubit(this._classService, this._parentService)
      : super(ParentClassInitial());
  final ClassService _classService;
  final ParentService _parentService;
  List<Lesson>? _lessons;
  List<Exercise>? _exercises;
  List<Submission>? _submissions;
  Comment? _comment;
  Future<void> fetchClass(String classId) async {
    emit(ParentClassLoading());
    _lessons = await _classService.fetchLessons(classId);
    _exercises = await _classService.fetchExercise(classId);
    _submissions = await _classService.listSubmissions(classId);
    emit(ParentClassFetched(_lessons!, _exercises!, _submissions!, _comment));
  }

  Future<void> updateLesson(String id, Lesson newLesson) async {
    bool result = await _classService.updateLesson(id, newLesson);
    if (result) {
      final index = _lessons?.indexWhere((lesson) => lesson.id == id);
      _lessons?[index!] = newLesson;
      emit(ParentClassFetched(_lessons!, _exercises!, _submissions!, _comment));
    }
  }

  Future<void> onFilePressed(FileName fileName) async {
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

  void openFile(String path) => emit(ParentClassOpenFile(path));

  Future<void> downloadFileAttach(FileName fileName) async {
    changeStateForFileName(fileName, DownloadState.downloading);
    emit(ParentClassFetched(_lessons!, _exercises!, _submissions!, _comment));
    final downloader = DownloaderServiceIml.instance;
    await downloader.download(fileName);
    changeStateForFileName(fileName, DownloadState.downloaded);
    emit(ParentClassFetched(_lessons!, _exercises!, _submissions!, _comment));
  }

  void changeStateForFileName(FileName fileName, DownloadState state) {
    final fileNameTmp = fileName.copyWith(state: state);
    final searchExc = _exercises!
        .indexWhere((excercise) => excercise.fileNames!.contains(fileName));
    _exercises![searchExc]
            .fileNames![_exercises![searchExc].fileNames!.indexOf(fileName)] =
        fileNameTmp;
  }

  Future<void> rateConsultant(
    String classId,
    double rate,
    String content,
  ) async {
    _parentService.rateConsultant(classId, rate, content);
  }

  void dispose() {
    _lessons = null;
    _exercises = null;
    _submissions = null;
    _comment = null;
    emit(ParentClassInitial());
  }
}
