import 'package:consultant/models/class_model.dart';
import 'package:consultant/models/exercise_model.dart';

abstract class ClassState {}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassFethed extends ClassState {
  final List<Class> classes;
  ClassFethed(this.classes);
}

class ClassExerciseFetched extends ClassState {
  final List<Exercise> exercises;
  ClassExerciseFetched(this.exercises);
}

class ClassExerciseInitial extends ClassState {}
