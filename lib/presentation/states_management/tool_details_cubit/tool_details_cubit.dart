import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tool.dart';
import '../../../domain/use_cases/tool_use_cases/tool_use_cases.dart';
import '../../helpers/functions.dart';

part 'tool_details_state.dart';

class ToolDetailsCubit extends Cubit<ToolDetailsState> {
  final GetToolByIdUseCase _getToolByIdUseCase;
  final UpdateToolUseCase _updateToolUseCase;

  ToolDetailsCubit(
    this._getToolByIdUseCase,
    this._updateToolUseCase,
  ) : super(ToolDetailsInitial());

  //================================================================================================
  getToolById(String id) async {
    emit(ToolDetailsLoading());
    final result = await _getToolByIdUseCase(id);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(result.asValue!.value));
    }
  }

  //================================================================================================
  returnTool(Tool tool) async {
    emit(ToolDetailsLoading());
    Tool updatedTool = Tool(
      id: tool.id,
      name: tool.name,
      date: getCurrentDate(),
      giver: tool.giver,
      holder: tool.holder,
      receiver: tool.giver,
    );
    final result = await _updateToolUseCase(updatedTool);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(updatedTool));
    }
  }

  //================================================================================================
  confirm(Tool tool) async {
    emit(ToolDetailsLoading());
    Tool updatedTool = Tool(
      id: tool.id,
      name: tool.name,
      date: getCurrentDate(),
      giver: tool.holder,
      holder: tool.receiver!,
      receiver: null,
    );
    final result = await _updateToolUseCase(updatedTool);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(updatedTool));
    }
  }

  //================================================================================================
  cancel(Tool tool) async {
    emit(ToolDetailsLoading());
    Tool updatedTool = Tool(
      id: tool.id,
      name: tool.name,
      date: getCurrentDate(),
      giver: tool.giver,
      holder: tool.holder,
      receiver: null,
    );
    final result = await _updateToolUseCase(updatedTool);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(updatedTool));
    }
  }

  //================================================================================================
  transfer(Tool tool, String receiver) async {
    emit(ToolDetailsLoading());
    Tool updatedTool = Tool(
      id: tool.id,
      name: tool.name,
      date: getCurrentDate(),
      giver: tool.giver,
      holder: tool.holder,
      receiver: receiver,
    );
    final result = await _updateToolUseCase(updatedTool);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(updatedTool));
    }
  }
  //================================================================================================
}
