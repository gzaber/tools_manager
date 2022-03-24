import 'package:async/async.dart';

import '../../entities/user.dart';
import '../../repositories/i_tool_repository.dart';
import '../../repositories/i_user_repository.dart';

class CountToolsAtUsersUseCase {
  final IToolRepository _toolRepository;
  final IUserRepository _userRepository;
  CountToolsAtUsersUseCase(this._toolRepository, this._userRepository);

  Future<Result<int>> call() async {
    try {
      int toolsCounter = 0;

      List<User> users = await _userRepository.getByRole('user');
      if (users.isNotEmpty) {
        for (User user in users) {
          int userToolsCounter = await _toolRepository.countInStockByUser(user.name);
          toolsCounter += userToolsCounter;
        }
      }

      return Result.value(toolsCounter);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
