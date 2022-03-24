import 'package:async/async.dart';

import '../../../data/models/user_model.dart';
import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class UpdateUserUseCase {
  final IUserRepository _userRepository;
  UpdateUserUseCase(this._userRepository);

  Future<Result<void>> call(UserModel userModel) async {
    try {
      if (userModel.name.isEmpty) return Result.error(failureUsernameEmpty);
      if (userModel.mobileNumber.isEmpty) return Result.error(failureMobileNumberEmpty);

      var usernameResult = await _userRepository.getByName(userModel.name);
      if (usernameResult != null && usernameResult.id != userModel.id) {
        return Result.error(failureUsernameExists);
      }

      var mobileNumberResult = await _userRepository.getByMobileNumber(userModel.mobileNumber);
      if (mobileNumberResult != null && mobileNumberResult.id != userModel.id) {
        return Result.error(failureMobileNumberExists);
      }

      User user = User(
        id: userModel.id,
        name: userModel.name,
        mobileNumber: userModel.mobileNumber,
        role: userModel.role,
      );

      return Result.value(await _userRepository.update(user));
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
