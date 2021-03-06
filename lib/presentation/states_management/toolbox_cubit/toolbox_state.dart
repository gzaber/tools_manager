part of 'toolbox_cubit.dart';

abstract class ToolboxState extends Equatable {
  @override
  List<Object> get props => [];
}

//==================================================================================================
class ToolboxInitial extends ToolboxState {}

//==================================================================================================
class ToolboxLoading extends ToolboxState {}

//==================================================================================================
class ToolboxLoadSuccess extends ToolboxState {
  final List<Tool> tools;

  ToolboxLoadSuccess(this.tools);

  @override
  List<Object> get props => [tools];
}

//==================================================================================================
class ToolboxLoadFailure extends ToolboxState {
  final String message;

  ToolboxLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

//==================================================================================================
class ToolboxManageToolSuccess extends ToolboxState {
  final ManageToolSuccessInfo message;

  ToolboxManageToolSuccess(this.message);

  @override
  List<Object> get props => [message];
}

//==================================================================================================
class ToolboxManageToolFailure extends ToolboxState {
  final String message;

  ToolboxManageToolFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================