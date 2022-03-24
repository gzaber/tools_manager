import 'package:async/async.dart';

import '../../repositories/i_user_repository.dart';
import '../../services/i_auth_service.dart';
import '../failure_codes.dart';

class VerifyMobileNumberUseCase {
  final IAuthService _authService;
  final IUserRepository _userRepository;

  VerifyMobileNumberUseCase(this._authService, this._userRepository);

  Future<Result<String>> call(String mobileNumber) async {
    try {
      if (mobileNumber.isEmpty) return Result.error(failureMobileNumberEmpty);

      var result = await _userRepository.getByMobileNumber(mobileNumber);
      if (result == null) return Result.error(failureMobileNumberNotAllowed);

      return await _authService.verifyMobileNumber(mobileNumber);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
