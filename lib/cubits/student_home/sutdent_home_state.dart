import '../../models/class_model.dart';

abstract class StudentHomeState {}

class StudentHomeInitial extends StudentHomeState {}

class StudentHomeLoading extends StudentHomeState {}

class StudentHomeClassFetched extends StudentHomeState {
  final List<Class> classes;
  StudentHomeClassFetched(this.classes);
}
