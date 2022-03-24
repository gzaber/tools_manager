import 'package:async/async.dart';

import '../../repositories/i_user_repository.dart';

class CountUsersByRoleUseCase {
  final IUserRepository _userRepository;

  CountUsersByRoleUseCase(this._userRepository);

  Future<Result<int>> call(String role) async {
    try {
      int counter = await _userRepository.countByRole(role);

      return Result.value(counter);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
