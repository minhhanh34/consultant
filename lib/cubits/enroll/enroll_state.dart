abstract class EnrollState {}

class EnrollInitial extends EnrollState {}

class EnrollLoading extends EnrollState {}

class EnrollMessage extends EnrollState {
  String message;
  EnrollMessage(this.message);
}

class EnrollSuccess extends EnrollState {
  String classId;
  String studentId;
  EnrollSuccess(this.classId, this.studentId);
}
