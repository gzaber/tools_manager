import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/tool_model.dart';
import '../../../domain/use_cases/common_use_cases/common_use_cases.dart';
import '../../../domain/use_cases/tool_use_cases/tool_use_cases.dart';

part 'tool_room_state.dart';

class ToolRoomCubit extends Cubit<ToolRoomState> {
  final GetToolsInToolRoomUseCase _getToolsInToolRoomUseCase;
  final GetToolsAtUsersUseCase _getToolsAtUsersUseCase;
  final GetAllPendingToolsUseCase _getPendingToolsUseCase;

  ToolRoomCubit(
    this._getToolsInToolRoomUseCase,
    this._getToolsAtUsersUseCase,
    this._getPendingToolsUseCase,
  ) : super(ToolRoomInitial());

  //=================================================================================================
  getInToolRoom() async {
    emit(ToolRoomLoading());
    final result = await _getToolsInToolRoomUseCase();
    if (result.asError != null) {
      emit(ToolRoomFailure(result.asError!.error.toString()));
    } else {
      emit(ToolRoomLoadSuccess(result.asValue!.value));
    }
  }

  //=================================================================================================
  getAtUsers() async {
    emit(ToolRoomLoading());
    final result = await _getToolsAtUsersUseCase();
    if (result.asError != null) {
      emit(ToolRoomFailure(result.asError!.error.toString()));
    } else {
      emit(ToolRoomLoadSuccess(result.asValue!.value));
    }
  }

  //=================================================================================================
  getPending() async {
    emit(ToolRoomLoading());
    final result = await _getPendingToolsUseCase();
    if (result.asError != null) {
      emit(ToolRoomFailure(result.asError!.error.toString()));
    } else {
      emit(ToolRoomLoadSuccess(result.asValue!.value));
    }
  }
  //=================================================================================================
}
