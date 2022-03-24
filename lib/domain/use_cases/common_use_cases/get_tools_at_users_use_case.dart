import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../entities/user.dart';
import '../../repositories/i_tool_repository.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetToolsAtUsersUseCase {
  final IToolRepository _toolRepository;
  final IUserRepository _userRepository;
  GetToolsAtUsersUseCase(this._toolRepository, this._userRepository);

  Future<Result<List<Tool>>> call() async {
    try {
      List<Tool> userTools = [];

      List<User> users = await _userRepository.getByRole('user');
      if (users.isNotEmpty) {
        for (User user in users) {
          var tools = await _toolRepository.getInStockByUser(user.name);
          userTools = List.from(userTools)..addAll(tools);
        }
      }

      if (userTools.isEmpty) return Result.error(failureNoToolsFound);

      userTools.sort((a, b) => a.name.compareTo(b.name));

      return Result.value(userTools);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
