import 'package:async/async.dart';

import '../../../data/models/user_model.dart';
import '../../entities/user.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetAllUsersUseCase {
  final IUserRepository _userRepository;
  GetAllUsersUseCase(this._userRepository);

  Future<Result<List<UserModel>>> call() async {
    try {
      List<User> users = await _userRepository.getAll();

      if (users.isEmpty) return Result.error(failureNoUsersFound);

      users.sort((a, b) => a.name.compareTo(b.name));

      List<UserModel> userModels = users
          .map(
            (user) => UserModel(
              id: user.id,
              name: user.name,
              mobileNumber: user.mobileNumber,
              role: user.role,
            ),
          )
          .toList();

      return Result.value(userModels);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
