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
  final List<ToolModel> toolModels;

  UserDetailsLoadSuccess(this.toolModels);

  @override
  List<Object> get props => [toolModels];
}

//==================================================================================================
class UserDetailsFailure extends UserDetailsState {
  final String message;

  UserDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================