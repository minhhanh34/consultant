import 'package:consultant/cubits/enroll/enroll_state.dart';
import 'package:consultant/models/student_model.dart';
import 'package:consultant/services/class_service.dart';
import 'package:consultant/services/student_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnrollCubit extends Cubit<EnrollState> {
  EnrollCubit(this._service, this._studentService) : super(EnrollInitial());
  final ClassService _service;
  final StudentService _studentService;
  String message = '';
  void sendMessage(String message) => emit(EnrollMessage(message));

  void enroll(String id, Student student) async {
    final oldState = state;
    emit(EnrollLoading());
    if (id.isEmpty) {
      message = 'không được bỏ trống';
      emit(EnrollMessage(message));
      return;
    }
    bool isSuccess = await _service.enroll(id, student);
    student.classIds.add(id);
    await _studentService.updateStudent(student);
    if (!isSuccess) {
      message = 'Mã lớp học không chính xác';
      emit(EnrollMessage(message));
      return;
    }
    emit(EnrollSuccess(id, student.id!));
    emit(oldState);
  }

  void dispose() {
    message = '';
    emit(EnrollInitial());
  }
}
