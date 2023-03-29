abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState{}
class AuthSignUpSuccessed extends AuthState{}
class AuthSignInSuccessed extends AuthState{}
class AuthInvalid extends AuthState {}
class AuthSignOuted extends AuthState {}