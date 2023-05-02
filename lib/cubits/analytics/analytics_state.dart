import '../../models/lesson.dart';

abstract class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsFetched extends AnalyticsState {
  AnalyticsFetched({
    required this.finishedLessons,
    required this.unfinishedLessons,
    required this.price,
  });
  final List<Lesson> finishedLessons;
  final List<Lesson> unfinishedLessons;
  final double price;
}
