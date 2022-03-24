import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tool.dart';
import '../../../domain/use_cases/tool_use_cases/get_tools_by_user_use_case.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final GetToolsByUserUseCase _getToolsByUserUseCase;

  UserDetailsCubit(
    this._getToolsByUserUseCase,
  ) : super(UserDetailsInitial());

  getUserTools(String username) async {
    emit(UserDetailsLoading());
    final toolsByUserResult = await _getToolsByUserUseCase(username);

    if (toolsByUserResult.asError != null) {
      emit(UserDetailsFailure('No tools found'));
    } else {
      emit(UserDetailsLoadSuccess(toolsByUserResult.asValue!.value));
    }
  }
}
