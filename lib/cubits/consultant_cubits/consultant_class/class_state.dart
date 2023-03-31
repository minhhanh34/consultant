import 'package:consultant/models/class_model.dart';
import 'package:consultant/models/exercise_model.dart';

import '../../../models/student_model.dart';
import '../../../models/submission_model.dart';

abstract class ClassState {}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassDetailFethed extends ClassState {
  final List<Exercise> exercises;
  final List<Student> students;
  ClassDetailFethed({
    required this.exercises,
    required this.students,
  });
}

class ClassFethed extends ClassState {
  final List<Class> classes;
  ClassFethed(this.classes);
}

class ClassExerciseFetched extends ClassState {
  final List<Exercise> exercises;
  ClassExerciseFetched(this.exercises);
}

class ClassExerciseInitial extends ClassState {}

class DownloadingExerciseAttachFile extends ClassState {}

class OpenExerciseAttachFile extends ClassState {
  final String path;
  OpenExerciseAttachFile(this.path);
}

class ClassStudentFetched extends ClassState {
  List<Student> students;
  ClassStudentFetched(this.students);
}

class ClassSubmissions extends ClassState {
  List<Submission> submissions;
  ClassSubmissions(this.submissions);
}

class ClassMarked extends ClassState {}
