import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class MoveDeletedUserToolsUseCase {
  final IToolRepository _toolRepository;
  final IUserRepository _userRepository;

  MoveDeletedUserToolsUseCase(this._toolRepository, this._userRepository);

  Future<Result<void>> call(String deletedUserId, String targetUsername) async {
    try {
      var result = await _userRepository.getById(deletedUserId);

      if (result == null) return Result.error(failureUserNotFound);

      List<Tool> toolsByGiver = await _toolRepository.getByGiver(result.name);
      if (toolsByGiver.isNotEmpty) {
        for (Tool tool in toolsByGiver) {
          await _toolRepository.update(
            Tool(
              id: tool.id,
              name: tool.name,
              date: tool.date,
              giver: tool.holder != targetUsername ? targetUsername : null,
              holder: tool.holder,
              receiver: tool.receiver,
            ),
          );
        }
      }

      List<Tool> toolsByHolder = await _toolRepository.getByHolder(result.name);
      if (toolsByHolder.isNotEmpty) {
        for (Tool tool in toolsByHolder) {
          await _toolRepository.update(
            Tool(
              id: tool.id,
              name: tool.name,
              date: tool.date,
              giver: tool.giver != targetUsername ? tool.giver : null,
              holder: targetUsername,
              receiver: tool.receiver != targetUsername ? tool.receiver : null,
            ),
          );
        }
      }
      List<Tool> toolsByReceiver = await _toolRepository.getByReceiver(result.name);
      if (toolsByReceiver.isNotEmpty) {
        for (Tool tool in toolsByReceiver) {
          await _toolRepository.update(
            Tool(
              id: tool.id,
              name: tool.name,
              date: tool.date,
              giver: tool.giver,
              holder: tool.holder,
              receiver: tool.holder != targetUsername ? targetUsername : null,
            ),
          );
        }
      }
      return Result.value(null);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
