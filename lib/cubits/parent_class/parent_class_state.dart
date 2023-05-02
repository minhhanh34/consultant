// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:consultant/models/comment_model.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/models/submission_model.dart';

import '../../models/lesson.dart';

abstract class ParentClassState {}

class ParentClassInitial extends ParentClassState {}

class ParentClassLoading extends ParentClassState {}

class ParentClassFetched extends ParentClassState {
  final List<Lesson> lessons;
  final List<Exercise> excercises;
  final List<Submission> submissions;
  final Comment? comment;
  ParentClassFetched(
    this.lessons,
    this.excercises,
    this.submissions,
    this.comment,
  );
}

class ParentClassOpenFile extends ParentClassState {
  final String path;
  ParentClassOpenFile(this.path);
}
