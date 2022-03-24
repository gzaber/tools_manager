part of 'users_cubit.dart';

abstract class UsersState extends Equatable {
  @override
  List<Object> get props => [];
}

//==================================================================================================
class UsersInitial extends UsersState {}

//==================================================================================================
class UsersLoading extends UsersState {}

//==================================================================================================
class UsersLoadSuccess extends UsersState {
  final List<User> users;
  final List<int> toolsInStockCounters;
  final List<int> transferredToolsCounters;
  final List<int> receivedToolsCounters;

  UsersLoadSuccess(
    this.users,
    this.toolsInStockCounters,
    this.transferredToolsCounters,
    this.receivedToolsCounters,
  );

  @override
  List<Object> get props => [
        users,
        toolsInStockCounters,
        transferredToolsCounters,
        receivedToolsCounters
      ];
}

//==================================================================================================
class UsersFailure extends UsersState {
  final String message;

  UsersFailure(this.message);

  @override
  List<Object> get props => [message];
}

//==================================================================================================
class UsersManageUserSuccess extends UsersState {
  final ManageUserSuccessInfo message;

  UsersManageUserSuccess(this.message);

  @override
  List<Object> get props => [message];
}

//==================================================================================================
class UsersManageUserFailure extends UsersState {
  final String message;

  UsersManageUserFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================