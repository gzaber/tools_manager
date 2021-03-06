part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

//==================================================================================================
class AuthInitial extends AuthState {}

//==================================================================================================
class AuthLoading extends AuthState {}

//==================================================================================================
class AuthVerificationSucces extends AuthState {
  final String verificationId;

  const AuthVerificationSucces(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

//==================================================================================================
class AuthSignInSuccess extends AuthState {
  final User user;

  const AuthSignInSuccess(this.user);

  @override
  List<Object> get props => [user];
}

//==================================================================================================
class AuthSignOutSuccess extends AuthState {}

//==================================================================================================
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

//==================================================================================================
class AuthPersistenceFailure extends AuthState {
  final String message;

  const AuthPersistenceFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================
