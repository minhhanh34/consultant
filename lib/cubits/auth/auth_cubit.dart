import 'package:consultant/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._service) : super(AuthInitial());
  final AuthService _service;
}
