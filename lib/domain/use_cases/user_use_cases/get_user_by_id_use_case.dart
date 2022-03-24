import 'package:async/async.dart';

import '../../../data/models/user_model.dart';
import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetUserByIdUseCase {
  final IUserRepository _userRepository;
  GetUserByIdUseCase(this._userRepository);

  Future<Result<UserModel>> call(String id) async {
    try {
      User? user = await _userRepository.getById(id);

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
