import 'package:async/async.dart';

import '../../../data/models/tool_model.dart';
import '../../entities/tool.dart';
import '../../entities/user.dart';
import '../../repositories/i_tool_repository.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetToolsAtUsersUseCase {
  final IToolRepository _toolRepository;
  final IUserRepository _userRepository;
  GetToolsAtUsersUseCase(this._toolRepository, this._userRepository);

  Future<Result<List<ToolModel>>> call() async {
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

      List<ToolModel> toolModels = userTools
          .map(
            (tool) => ToolModel(
              id: tool.id,
              name: tool.name,
              date: tool.date,
              giver: tool.giver,
              holder: tool.holder,
              receiver: tool.receiver,
            ),
          )
          .toList();
      return Result.value(toolModels);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
