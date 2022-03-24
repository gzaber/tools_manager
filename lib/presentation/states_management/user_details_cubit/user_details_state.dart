part of 'user_details_cubit.dart';

abstract class UserDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

//==================================================================================================
class UserDetailsInitial extends UserDetailsState {}

//==================================================================================================
class UserDetailsLoading extends UserDetailsState {}

//==================================================================================================
class UserDetailsLoadSuccess extends UserDetailsState {
  final List<Tool> tools;

  UserDetailsLoadSuccess(this.tools);

  @override
  List<Object> get props => [tools];
}

//==================================================================================================
class UserDetailsFailure extends UserDetailsState {
  final String message;

  UserDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================