import 'package:async/async.dart';

import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class AddUserUseCase {
  final IUserRepository _userRepository;

  AddUserUseCase(this._userRepository);

  Future<Result<void>> call(String username, String mobileNumber, String role) async {
    try {
      if (username.isEmpty) return Result.error(failureUsernameEmpty);
      if (mobileNumber.isEmpty) return Result.error(failureMobileNumberEmpty);

      var usernameResult = await _userRepository.getByName(username);
      if (usernameResult != null) return Result.error(failureUsernameExists);

      var mobileNumberResult = await _userRepository.getByMobileNumber(mobileNumber);
      if (mobileNumberResult != null) {
        return Result.error(failureMobileNumberExists);
      }

      User user = User(
        mobileNumber: mobileNumber,
        name: username,
        role: role,
      );
      return Result.value(await _userRepository.add(user));
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
