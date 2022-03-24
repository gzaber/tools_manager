import 'package:async/async.dart';

import '../../../data/models/user_model.dart';
import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../../services/i_auth_service.dart';
import '../failure_codes.dart';

class CheckPersistedAuthStateUseCase {
  final IAuthService _authService;
  final IUserRepository _userRepository;

  CheckPersistedAuthStateUseCase(this._authService, this._userRepository);

  Future<Result<UserModel>> call() async {
    try {
      String? mobileNumber = _authService.checkPersistedAuthState();
      if (mobileNumber == null) return Result.error(failureNoUsersFound);

      User? user = await _userRepository.getByMobileNumber(mobileNumber);

      if (user == null) return Result.error(failureNoUsersFound);

      UserModel userModel = UserModel(
        id: user.id,
        name: user.name,
        mobileNumber: user.mobileNumber,
        role: user.role,
      );

      return Result.value(userModel);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
