import 'package:async/async.dart';

import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetUserByMobileNumberUseCase {
  final IUserRepository _userRepository;
  GetUserByMobileNumberUseCase(this._userRepository);

  Future<Result<User>> call(String mobileNumber) async {
    try {
      User? user = await _userRepository.getByMobileNumber(mobileNumber);

      if (user == null) return Result.error(failureUserNotFound);

      return Result.value(user);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
