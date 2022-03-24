part of 'tool_room_cubit.dart';

abstract class ToolRoomState extends Equatable {
  @override
  List<Object> get props => [];
}

//==================================================================================================
class ToolRoomInitial extends ToolRoomState {}

//==================================================================================================
class ToolRoomLoading extends ToolRoomState {}

//==================================================================================================
class ToolRoomLoadSuccess extends ToolRoomState {
  final List<Tool> tools;

  ToolRoomLoadSuccess(this.tools);

  @override
  List<Object> get props => [tools];
}

//==================================================================================================
class ToolRoomFailure extends ToolRoomState {
  final String message;

  ToolRoomFailure(this.message);

  @override
  List<Object> get props => [message];
}
//==================================================================================================