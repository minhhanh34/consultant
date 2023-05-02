import 'package:consultant/models/lesson.dart';
import 'package:consultant/services/consultant_service.dart';
import 'package:consultant/services/lesson_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/consultant_model.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(
    this._consultantService,
    this._lessonService,
  ) : super(AnalyticsInitial());
  // services
  final ConsultantService _consultantService;
  final LessonService _lessonService;
  double? _price;
  // variable cached
  List<Lesson>? _finishedLessons;
  List<Lesson>? _unfinishedLessons;
  Future<void> getAnalytics(Consultant consultant) async {
    emit(AnalyticsLoading());
    List<Lesson> lessons = await _lessonService.list(consultant.id!);
    _finishedLessons = lessons.where((lesson) => lesson.isCompleted).toList();
    _unfinishedLessons =
        lessons.where((lesson) => !lesson.isCompleted).toList();
    //TODO update price
    _price = 80000;
    emit(AnalyticsFetched(
      finishedLessons: _finishedLessons!,
      unfinishedLessons: _unfinishedLessons!,
      price: _price!,
    ));
  }
}
