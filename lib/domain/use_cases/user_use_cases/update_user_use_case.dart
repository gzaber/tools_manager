import 'package:async/async.dart';

import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class UpdateUserUseCase {
  final IUserRepository _userRepository;
  UpdateUserUseCase(this._userRepository);

  Future<Result<void>> call(User user) async {
    try {
      if (user.name.isEmpty) return Result.error(failureUsernameEmpty);
      if (user.mobileNumber.isEmpty) {
        return Result.error(failureMobileNumberEmpty);
      }

      var usernameResult = await _userRepository.getByName(user.name);
      if (usernameResult != null && usernameResult.id != user.id) {
        return Result.error(failureUsernameExists);
      }

      var mobileNumberResult =
          await _userRepository.getByMobileNumber(user.mobileNumber);
      if (mobileNumberResult != null && mobileNumberResult.id != user.id) {
        return Result.error(failureMobileNumberExists);
      }

      return Result.value(await _userRepository.update(user));
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
