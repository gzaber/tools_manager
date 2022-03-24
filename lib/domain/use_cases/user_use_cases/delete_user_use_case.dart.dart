import 'package:async/async.dart';

import '../../repositories/i_user_repository.dart';

class DeleteUserUseCase {
  final IUserRepository _userRepository;
  DeleteUserUseCase(this._userRepository);

  Future<Result<void>> call(String id) async {
    try {
      return Result.value(await _userRepository.delete(id));
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
