import 'package:consultant/cubits/student_home/sutdent_home_state.dart';
import 'package:consultant/models/class_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/student_model.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  StudentHomeCubit(this._service) : super(StudentHomeInitial());
  final ClassService _service;

  List<Class>? _classes;

  Future<void> fetchClasses(Student student) async {
    emit(StudentHomeLoading());
    _classes ??= await _service.fetchClassesForStudent(student);
    emit(StudentHomeClassFetched(_classes!));
  }
}
