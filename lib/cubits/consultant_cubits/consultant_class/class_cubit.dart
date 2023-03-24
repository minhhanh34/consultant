import 'package:consultant/cubits/consultant_cubits/consultant_class/class_state.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/class_model.dart';

class ClassCubit extends Cubit<ClassState> {
  ClassCubit(this._service) : super(ClassInitial());
  final ClassService _service;
  List<Class>? _classes;
  List<Exercise>? _exercises;

  void fetchClasses(String id) async {
    emit(ClassLoading());
    _classes ??= await _service.fetchClasses(id);
    emit(ClassFethed(_classes!));
  }

  Future<Class> createClass(Class cla) async {
    emit(ClassLoading());
    final newClass = await _service.create(cla);
    _classes?.add(newClass);
    emit(ClassFethed(_classes!));
    return newClass;
  }

  void createExercise(String id, Exercise exercise) async {
    final newExc = await _service.createExercise(id, exercise);
    _exercises?.add(newExc);
    emit(ClassExerciseFetched(_exercises!));
  }

  void fetchExercises(String id) async {
    emit(ClassLoading());
    _exercises = await _service.fetchExercise(id);
    emit(ClassExerciseFetched(_exercises!));
  }

  void goToClass() => emit(ClassExerciseInitial());

  void deleteExcercise(String classId, Exercise exercise) async {
    await _service.deleteExcercise(classId, exercise.id!);
    _exercises?.remove(exercise);
    emit(ClassExerciseFetched(_exercises!));
   
  }

  void onLoading() => emit(ClassLoading());

  // Future<void> downloadFileAttach(String path) async {

  // }
}
