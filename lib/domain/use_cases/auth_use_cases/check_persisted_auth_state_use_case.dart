import 'package:async/async.dart';

import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../../services/i_auth_service.dart';
import '../failure_codes.dart';

class CheckPersistedAuthStateUseCase {
  final IAuthService _authService;
  final IUserRepository _userRepository;

  CheckPersistedAuthStateUseCase(this._authService, this._userRepository);

  Future<Result<User>> call() async {
    try {
      String? mobileNumber = _authService.checkPersistedAuthState();
      if (mobileNumber == null) return Result.error(failureNoUsersFound);

      User? user = await _userRepository.getByMobileNumber(mobileNumber);

      if (user == null) return Result.error(failureNoUsersFound);

      return Result.value(user);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
