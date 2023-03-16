import 'package:consultant/cubits/consultant_cubits/consultant_class/class_state.dart';
import 'package:consultant/services/class_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/class_model.dart';

class ClassCubit extends Cubit<ClassState> {
  ClassCubit(this._service) : super(ClassInitial());
  final ClassService _service;
  List<Class>? classes;

  void fetchClasses(String id) async {
    emit(ClassLoading());
    classes ??= await _service.fetchClasses(id);
    emit(ClassFethed(classes!));
  }
}
