import 'package:async/async.dart';

import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetUserByIdUseCase {
  final IUserRepository _userRepository;
  GetUserByIdUseCase(this._userRepository);

  Future<Result<User>> call(String id) async {
    try {
      User? user = await _userRepository.getById(id);

      if (user == null) return Result.error(failureUserNotFound);

      return Result.value(user);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
