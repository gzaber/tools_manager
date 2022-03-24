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
  final List<UserModel> userModels;

  TransferToolLoadSuccess(this.userModels);

  @override
  List<Object> get props => [userModels];
}

//==================================================================================================
class TransferToolFailure extends TransferToolState {
  final String message;

  TransferToolFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================