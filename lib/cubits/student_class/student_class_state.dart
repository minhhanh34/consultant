import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/models/submission_model.dart';

abstract class StudentClassState {}

class StudentClassInitlal extends StudentClassState {}

class StudentClassLoading extends StudentClassState {}

class StudentClassExerciseFetched extends StudentClassState {
  List<Exercise> exercises;
  List<Submission> submissions;
  StudentClassExerciseFetched(this.exercises, this.submissions);
}

class StudentClassOpenFile extends StudentClassState {
  String path;
  StudentClassOpenFile(this.path);
}
