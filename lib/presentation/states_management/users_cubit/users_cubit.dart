import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/common_use_cases/common_use_cases.dart';
import '../../../domain/use_cases/tool_use_cases/tool_use_cases.dart';
import '../../../domain/use_cases/user_use_cases/user_use_cases.dart';
import '../../helpers/helpers.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final CountToolsInStockByUserUseCase _countToolsInStockByUserUseCase;
  final CountTransferredToolsByUserUseCase _countTransferredToolsByUserUseCase;
  final CountReceivedToolsByUserUseCase _countReceivedToolsByUserUseCase;
  final AddUserUseCase _addUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final UpdateToolsByUserIdUseCase _updateToolsByUserIdUseCase;
  final MoveDeletedUserToolsUseCase _moveDeletedUserToolsUseCase;

  UsersCubit(
    this._getAllUsersUseCase,
    this._countToolsInStockByUserUseCase,
    this._countTransferredToolsByUserUseCase,
    this._countReceivedToolsByUserUseCase,
    this._addUserUseCase,
    this._updateUserUseCase,
    this._deleteUserUseCase,
    this._updateToolsByUserIdUseCase,
    this._moveDeletedUserToolsUseCase,
  ) : super(UsersInitial());

  //================================================================================================
  getInfo() async {
    emit(UsersLoading());
    final usersResult = await _getAllUsersUseCase();
    if (usersResult.asError != null) {
      emit(UsersFailure(usersResult.asError!.error.toString()));
    } else {
      List<int> toolsInStockCounters = [];
      List<int> transferredToolsCounters = [];
      List<int> receivedToolsCounters = [];

      for (var user in usersResult.asValue!.value) {
        var toolsInStockCounterResult =
            await _countToolsInStockByUserUseCase(user.name);
        if (toolsInStockCounterResult.asError != null) {
          emit(UsersFailure(
              toolsInStockCounterResult.asError!.error.toString()));
          return;
        }
        toolsInStockCounters.add(toolsInStockCounterResult.asValue!.value);

        var transferredToolsCounterResult =
            await _countTransferredToolsByUserUseCase(user.name);
        if (transferredToolsCounterResult.asError != null) {
          emit(UsersFailure(
              transferredToolsCounterResult.asError!.error.toString()));
          return;
        }
        transferredToolsCounters
            .add(transferredToolsCounterResult.asValue!.value);

        var receivedToolsCounterResult =
            await _countReceivedToolsByUserUseCase(user.name);
        if (receivedToolsCounterResult.asError != null) {
          emit(UsersFailure(
              receivedToolsCounterResult.asError!.error.toString()));
          return;
        }
        receivedToolsCounters.add(receivedToolsCounterResult.asValue!.value);
      }

      emit(
        UsersLoadSuccess(
          usersResult.asValue!.value,
          toolsInStockCounters,
          transferredToolsCounters,
          receivedToolsCounters,
        ),
      );
    }
  }

  //================================================================================================
  addUser(String username, String mobileNumber, String role) async {
    emit(UsersLoading());
    final result = await _addUserUseCase(username, mobileNumber, role);
    if (result.asError != null) {
      emit(UsersManageUserFailure(result.asError!.error.toString()));
    } else {
      emit(UsersManageUserSuccess(ManageUserSuccessInfo.userAdded));
    }
  }

  //================================================================================================
  updateUser(User user) async {
    emit(UsersLoading());
    final updateToolsByUserIdResult =
        await _updateToolsByUserIdUseCase(user.id!, user.name);
    if (updateToolsByUserIdResult.asError != null) {
      emit(UsersManageUserFailure(
          updateToolsByUserIdResult.asError!.error.toString()));
      return;
    }
    final updateUserResult = await _updateUserUseCase(user);
    if (updateUserResult.asError != null) {
      emit(UsersManageUserFailure(updateUserResult.asError!.error.toString()));
      return;
    }
    emit(UsersManageUserSuccess(ManageUserSuccessInfo.userUpdated));
  }

  //================================================================================================
  deleteUser(String id, String targetUsername) async {
    emit(UsersLoading());
    final moveDeletedUserToolsResult =
        await _moveDeletedUserToolsUseCase(id, targetUsername);
    if (moveDeletedUserToolsResult.asError != null) {
      emit(UsersManageUserFailure(
          moveDeletedUserToolsResult.asError!.error.toString()));
      return;
    }
    final deleteUserResult = await _deleteUserUseCase(id);
    if (deleteUserResult.asError != null) {
      emit(UsersManageUserFailure(deleteUserResult.asError!.error.toString()));
      return;
    }
    emit(UsersManageUserSuccess(ManageUserSuccessInfo.userDeleted));
  }
  //================================================================================================

}
