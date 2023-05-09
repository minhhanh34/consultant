import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/utils/libs_for_main.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/lesson.dart';
import '../../services/downloader_service.dart';
import 'parent_class_state.dart';

class ParentClassCubit extends Cubit<ParentClassState> {
  ParentClassCubit(
    this._classService,
    this._parentService,
    this._consultantService,
  ) : super(ParentClassInitial());
  final ClassService _classService;
  final ParentService _parentService;
  final ConsultantService _consultantService;
  List<Lesson>? _lessons;
  List<Exercise>? _exercises;
  List<Submission>? _submissions;
  Comment? _comment;
  Future<void> fetchClass(String classId) async {
    emit(ParentClassLoading());
    _lessons = await _classService.fetchLessons(classId);
    _exercises = await _classService.fetchExercise(classId);
    _submissions = await _classService.listSubmissions(classId);
    _comment = await _classService.fetchComment(classId);
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

  Future<Comment> rateConsultant(
    String commentatorName,
    String commentatorAvatar,
    String consultantId,
    double rate,
    String content,
    String parentId,
  ) async {
    _comment = await _parentService.rateConsultant(
      commentatorAvatar: commentatorAvatar,
      commentatorName: commentatorName,
      consultantId: consultantId,
      rate: rate,
      content: content,
      parentId: parentId,
    );
    final consultant = await _consultantService.get(consultantId);
    int raters = 1;
    if (consultant.rate != null && consultant.raters != null) {
      rate = (consultant.rate! * consultant.raters! + rate) /
          (consultant.raters! + 1);
      raters += consultant.raters! + 1;
    }
    _consultantService.update(
      consultantId,
      consultant.copyWith(
        rate: rate,
        raters: raters,
      ),
    );
    emit(ParentClassFetched(_lessons!, _exercises!, _submissions!, _comment));
    return _comment!;
  }

  Future<bool> updateComment(
    String consultantId,
    String commentId,
    double oldRate,
    Comment comment,
  ) async {
    final result =
        await _parentService.updateComment(consultantId, commentId, comment);
    final consultant = await _consultantService.get(consultantId);
    _consultantService.update(
      consultantId,
      consultant.copyWith(
        rate: (consultant.rate! * consultant.raters! - oldRate + comment.rate) /
            consultant.raters!,
      ),
    );
    emit(ParentClassFetched(_lessons!, _exercises!, _submissions!, comment));
    return result;
  }

  void dispose() {
    _lessons = null;
    _exercises = null;
    _submissions = null;
    _comment = null;
    emit(ParentClassInitial());
  }
}
