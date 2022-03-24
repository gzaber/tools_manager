import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/use_cases/user_use_cases/get_all_users_use_case.dart';

part 'transfer_tool_state.dart';

class TransferToolCubit extends Cubit<TransferToolState> {
  final GetAllUsersUseCase _getAllUsersUseCase;

  TransferToolCubit(this._getAllUsersUseCase) : super(TransferToolInitial());

  getAllUsers() async {
    emit(TransferToolLoading());
    final result = await _getAllUsersUseCase();
    if (result.asError != null) {
      emit(TransferToolFailure(result.asError!.error.toString()));
    } else {
      emit(TransferToolLoadSuccess(result.asValue!.value));
    }
  }
}
