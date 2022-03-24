import 'package:async/async.dart';

import '../../../data/models/user_model.dart';
import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetUserByMobileNumberUseCase {
  final IUserRepository _userRepository;
  GetUserByMobileNumberUseCase(this._userRepository);

  Future<Result<UserModel>> call(String mobileNumber) async {
    try {
      User? user = await _userRepository.getByMobileNumber(mobileNumber);

      if (user == null) return Result.error(failureUserNotFound);

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
