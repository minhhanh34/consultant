import 'package:consultant/models/consultant_model.dart';

import '../../models/parent_model.dart';
import '../../models/student_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUpSuccessed extends AuthState {}

class AuthSignInSuccessed extends AuthState {}

class AuthInvalid extends AuthState {}

class AuthSignOuted extends AuthState {}

class AuthSignInConsultant extends AuthState {
  final Consultant consultant;
  AuthSignInConsultant(this.consultant);
}

class AuthSignInParent extends AuthState {
  final Parent parent;
  AuthSignInParent(this.parent);
}

class AuthSignInStudent extends AuthState {
  final Student student;
  AuthSignInStudent(this.student);
}

class AuthMessage extends AuthState {
  final String message;
  AuthMessage(this.message);
}
