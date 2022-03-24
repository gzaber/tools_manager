part of 'transfer_tool_cubit.dart';

abstract class TransferToolState extends Equatable {
  @override
  List<Object> get props => [];
}

//==================================================================================================
class TransferToolInitial extends TransferToolState {}

//==================================================================================================
class TransferToolLoading extends TransferToolState {}

//==================================================================================================
class TransferToolLoadSuccess extends TransferToolState {
  final List<User> users;

  TransferToolLoadSuccess(this.users);

  @override
  List<Object> get props => [users];
}

//==================================================================================================
class TransferToolFailure extends TransferToolState {
  final String message;

  TransferToolFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================