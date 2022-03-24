part of 'tool_details_cubit.dart';

abstract class ToolDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

//==================================================================================================
class ToolDetailsInitial extends ToolDetailsState {}

//==================================================================================================
class ToolDetailsLoading extends ToolDetailsState {}

//==================================================================================================
class ToolDetailsLoadSuccess extends ToolDetailsState {
  final Tool tool;

  ToolDetailsLoadSuccess(this.tool);

  @override
  List<Object> get props => [tool];
}

//==================================================================================================
class ToolDetailsFailure extends ToolDetailsState {
  final String message;

  ToolDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================