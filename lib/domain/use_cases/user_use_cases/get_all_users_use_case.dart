import 'package:async/async.dart';

import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetAllUsersUseCase {
  final IUserRepository _userRepository;
  GetAllUsersUseCase(this._userRepository);

  Future<Result<List<User>>> call() async {
    try {
      List<User> users = await _userRepository.getAll();

      if (users.isEmpty) return Result.error(failureNoUsersFound);

      users.sort((a, b) => a.name.compareTo(b.name));

      return Result.value(users);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
