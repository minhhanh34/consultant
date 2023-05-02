import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/student_home/sutdent_home_state.dart';
import 'package:consultant/models/class_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:consultant/services/student_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/student_model.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  StudentHomeCubit(this._service, this._studentService)
      : super(StudentHomeInitial());
  final ClassService _service;
  final StudentService _studentService;
  List<Class?>? _classes;
  Student? _student;
  Student? get student => _student;

  Future<void> fetchClassesForStudent(String id) async {
    emit(StudentHomeLoading());
    _student ??= await _studentService.getStudentByUid(AuthCubit.uid!);
    _classes ??= await _service.fetchClassesForStudent(_student!);
    emit(StudentHomeClassFetched(_classes!, _student!));
  }

  Future<void> refresh() async {
    _classes = null;
    fetchClassesForStudent(AuthCubit.currentUserId!);
  }

  Future<List<Student>> fetchClassStudents(String classId) async {
    return await _service.fetchStudents(classId);
  }

  Future<void> updateStudent(String id, Student student) async {
    await _studentService.updateStudent(id, student);
  }

  Future<void> onSettingTap() async {
    _student ??= await _studentService.getStudentByUid(AuthCubit.uid!);
    emit(StudentSettings(_student!));
  }

  Future<void> onClassTap() async {
    emit(StudentHome());
    emit(StudentHomeClassFetched(_classes!, _student!));
    // fetchClassStudents(AuthCubit.currentUserId!);
  }

  void onUpdate() => emit(StudentHomeUpdate(_student!));

  void dispose() {
    _student = null;
    _classes = null;
    emit(StudentHomeInitial());
  }
}
