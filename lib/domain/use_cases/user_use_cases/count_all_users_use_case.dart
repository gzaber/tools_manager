import 'package:async/async.dart';

import '../../repositories/i_user_repository.dart';

class CountAllUsersUseCase {
  final IUserRepository _userRepository;

  CountAllUsersUseCase(this._userRepository);

  Future<Result<int>> call() async {
    try {
      int counter = await _userRepository.countAll();

      return Result.value(counter);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
