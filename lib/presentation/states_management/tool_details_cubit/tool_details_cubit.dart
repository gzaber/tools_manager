import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/tool_model.dart';
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
  returnTool(ToolModel toolModel) async {
    emit(ToolDetailsLoading());
    ToolModel updatedToolModel = ToolModel(
      id: toolModel.id,
      name: toolModel.name,
      date: getCurrentDate(),
      giver: toolModel.giver,
      holder: toolModel.holder,
      receiver: toolModel.giver,
    );
    final result = await _updateToolUseCase(updatedToolModel);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(updatedToolModel));
    }
  }

  //================================================================================================
  confirm(ToolModel toolModel) async {
    emit(ToolDetailsLoading());
    ToolModel updatedToolModel = ToolModel(
      id: toolModel.id,
      name: toolModel.name,
      date: getCurrentDate(),
      giver: toolModel.holder,
      holder: toolModel.receiver!,
      receiver: null,
    );
    final result = await _updateToolUseCase(updatedToolModel);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(updatedToolModel));
    }
  }

  //================================================================================================
  cancel(ToolModel toolModel) async {
    emit(ToolDetailsLoading());
    ToolModel updatedToolModel = ToolModel(
      id: toolModel.id,
      name: toolModel.name,
      date: getCurrentDate(),
      giver: toolModel.giver,
      holder: toolModel.holder,
      receiver: null,
    );
    final result = await _updateToolUseCase(updatedToolModel);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(updatedToolModel));
    }
  }

  //================================================================================================
  transfer(ToolModel toolModel, String receiver) async {
    emit(ToolDetailsLoading());
    ToolModel updatedToolModel = ToolModel(
      id: toolModel.id,
      name: toolModel.name,
      date: getCurrentDate(),
      giver: toolModel.giver,
      holder: toolModel.holder,
      receiver: receiver,
    );
    final result = await _updateToolUseCase(updatedToolModel);
    if (result.asError != null) {
      emit(ToolDetailsFailure(result.asError!.error.toString()));
    } else {
      emit(ToolDetailsLoadSuccess(updatedToolModel));
    }
  }
  //================================================================================================
}
