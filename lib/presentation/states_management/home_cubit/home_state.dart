part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

//==================================================================================================
class HomeInitial extends HomeState {}

//==================================================================================================
class HomeLoading extends HomeState {}

//==================================================================================================
class HomeLoadSuccess extends HomeState {
  final int numberOfToolsInStock;
  final int numberOfTransferredTools;
  final int numberOfReceivedTools;
  final int numberOfToolsInToolRoom;
  final int numberOfToolsAtUsers;
  final int numberOfPendingTools;
  final int numberOfRoleMaster;
  final int numberOfRoleAdmin;
  final int numberOfRoleUser;

  HomeLoadSuccess(
    this.numberOfToolsInStock,
    this.numberOfTransferredTools,
    this.numberOfReceivedTools,
    this.numberOfToolsInToolRoom,
    this.numberOfToolsAtUsers,
    this.numberOfPendingTools,
    this.numberOfRoleMaster,
    this.numberOfRoleAdmin,
    this.numberOfRoleUser,
  );

  @override
  List<Object> get props => [
        numberOfToolsInStock,
        numberOfTransferredTools,
        numberOfReceivedTools,
        numberOfToolsInToolRoom,
        numberOfToolsAtUsers,
        numberOfPendingTools,
        numberOfRoleMaster,
        numberOfRoleAdmin,
        numberOfRoleUser,
      ];
}

//==================================================================================================
class HomeSignOutSuccess extends HomeState {}

//==================================================================================================
class HomeFailure extends HomeState {
  final String message;
  HomeFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================
