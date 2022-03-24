import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tool.dart';
import '../../../domain/use_cases/tool_use_cases/tool_use_cases.dart';
import '../../helpers/helpers.dart';

part 'toolbox_state.dart';

class ToolboxCubit extends Cubit<ToolboxState> {
  final GetToolsByUserUseCase _getToolsByUserUseCase;
  final AddToolUseCase _addToolUseCase;
  final UpdateToolUseCase _updateToolUseCase;
  final DeleteToolUseCase _deleteToolUseCase;

  ToolboxCubit(
    this._getToolsByUserUseCase,
    this._addToolUseCase,
    this._updateToolUseCase,
    this._deleteToolUseCase,
  ) : super(ToolboxInitial());

  //================================================================================================

  getTools(String username) async {
    emit(ToolboxLoading());
    final toolsByUserResult = await _getToolsByUserUseCase(username);

    if (toolsByUserResult.asError != null) {
      emit(ToolboxLoadFailure(toolsByUserResult.asError!.error.toString()));
    } else {
      emit(ToolboxLoadSuccess(toolsByUserResult.asValue!.value));
    }
  }

  //================================================================================================
  addTool(String name, String date, String holder) async {
    emit(ToolboxLoading());
    final result = await _addToolUseCase(name, date, holder);
    if (result.asError != null) {
      emit(ToolboxManageToolFailure(result.asError!.error.toString()));
    } else {
      emit(ToolboxManageToolSuccess(ManageToolSuccessInfo.toolAdded));
    }
  }

  //================================================================================================
  updateTool(Tool tool) async {
    emit(ToolboxLoading());
    final result = await _updateToolUseCase(tool);
    if (result.asError != null) {
      emit(ToolboxManageToolFailure(result.asError!.error.toString()));
    } else {
      emit(ToolboxManageToolSuccess(ManageToolSuccessInfo.toolUpdated));
    }
  }

  //================================================================================================
  deleteTool(String id) async {
    emit(ToolboxLoading());
    final result = await _deleteToolUseCase(id);
    if (result.asError != null) {
      emit(ToolboxManageToolFailure(result.asError!.error.toString()));
    } else {
      emit(ToolboxManageToolSuccess(ManageToolSuccessInfo.toolDeleted));
    }
  }
  //================================================================================================
}
