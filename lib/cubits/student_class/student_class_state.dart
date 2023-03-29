import 'package:consultant/models/exercise_model.dart';

abstract class StudentClassState {}

class StudentClassInitlal extends StudentClassState {}

class StudentClassLoading extends StudentClassState {}

class StudentClassExerciseFetched extends StudentClassState {
  List<Exercise> exercises;
  StudentClassExerciseFetched(this.exercises);
}

class StudentClassOpenFile extends StudentClassState {
  String path;
  StudentClassOpenFile(this.path);
}
