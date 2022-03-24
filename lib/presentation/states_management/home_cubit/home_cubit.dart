import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_cases/auth_use_cases/sign_out_use_case.dart';
import '../../../domain/use_cases/common_use_cases/common_use_cases.dart';
import '../../../domain/use_cases/tool_use_cases/tool_use_cases.dart';
import '../../../domain/use_cases/user_use_cases/user_use_cases.dart';
import '../../helpers/helpers.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SignOutUseCase _signOutUseCase;
  final CountToolsInStockByUserUseCase _countToolsInStockByUserUseCase;
  final CountTransferredToolsByUserUseCase _countTransferredToolsByUserUseCase;
  final CountReceivedToolsByUserUseCase _countReceivedToolsByUserUseCase;
  final CountToolsInToolRoomUseCase _countToolsInToolRoomUseCase;
  final CountToolsAtUsersUseCase _countToolsAtUsersUseCase;
  final CountAllPendingToolsUseCase _countPendingToolsUseCase;
  final CountUsersByRoleUseCase _countUsersByRoleUseCase;

  HomeCubit(
    this._signOutUseCase,
    this._countToolsInStockByUserUseCase,
    this._countTransferredToolsByUserUseCase,
    this._countReceivedToolsByUserUseCase,
    this._countToolsInToolRoomUseCase,
    this._countToolsAtUsersUseCase,
    this._countPendingToolsUseCase,
    this._countUsersByRoleUseCase,
  ) : super(HomeInitial());

  //================================================================================================
  signOut() async {
    emit(HomeLoading());
    var result = await _signOutUseCase();
    if (result.asError != null) {
      emit(HomeFailure(result.asError!.error.toString()));
    } else {
      emit(HomeSignOutSuccess());
    }
  }

  //================================================================================================
  getInfo(String username) async {
    emit(HomeLoading());
    final countToolsInStockResult = await _countToolsInStockByUserUseCase(username);
    if (countToolsInStockResult.asError != null) {
      emit(HomeFailure(countToolsInStockResult.asError!.error.toString()));
      return;
    }
    final countTransferredToolsResult = await _countTransferredToolsByUserUseCase(username);
    if (countTransferredToolsResult.asError != null) {
      emit(HomeFailure(countTransferredToolsResult.asError!.error.toString()));
      return;
    }
    final countReceivedToolsResult = await _countReceivedToolsByUserUseCase(username);
    if (countReceivedToolsResult.asError != null) {
      emit(HomeFailure(countReceivedToolsResult.asError!.error.toString()));
      return;
    }
    final countToolsInToolRoomResult = await _countToolsInToolRoomUseCase();
    if (countToolsInToolRoomResult.asError != null) {
      emit(HomeFailure(countToolsInToolRoomResult.asError!.error.toString()));
      return;
    }
    final countToolsAtUsersResult = await _countToolsAtUsersUseCase();
    if (countToolsAtUsersResult.asError != null) {
      emit(HomeFailure(countToolsAtUsersResult.asError!.error.toString()));
      return;
    }
    final countPendingToolsResult = await _countPendingToolsUseCase();
    if (countPendingToolsResult.asError != null) {
      emit(HomeFailure(countPendingToolsResult.asError!.error.toString()));
      return;
    }
    final countRoleMasterResult = await _countUsersByRoleUseCase(kRoleMaster);
    if (countRoleMasterResult.asError != null) {
      emit(HomeFailure(countRoleMasterResult.asError!.error.toString()));
      return;
    }
    final countRoleAdminResult = await _countUsersByRoleUseCase(kRoleAdmin);
    if (countRoleAdminResult.asError != null) {
      emit(HomeFailure(countRoleAdminResult.asError!.error.toString()));
      return;
    }
    final countRoleUserResult = await _countUsersByRoleUseCase(kRoleUser);
    if (countRoleUserResult.asError != null) {
      emit(HomeFailure(countRoleUserResult.asError!.error.toString()));
      return;
    }

    emit(
      HomeLoadSuccess(
        countToolsInStockResult.asValue!.value,
        countTransferredToolsResult.asValue!.value,
        countReceivedToolsResult.asValue!.value,
        countToolsInToolRoomResult.asValue!.value,
        countToolsAtUsersResult.asValue!.value,
        countPendingToolsResult.asValue!.value,
        countRoleMasterResult.asValue!.value,
        countRoleAdminResult.asValue!.value,
        countRoleUserResult.asValue!.value,
      ),
    );
  }
}
