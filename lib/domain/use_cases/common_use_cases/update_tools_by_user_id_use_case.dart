import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class UpdateToolsByUserIdUseCase {
  final IToolRepository _toolRepository;
  final IUserRepository _userRepository;

  UpdateToolsByUserIdUseCase(this._toolRepository, this._userRepository);

  Future<Result<void>> call(String userId, String updatedUsername) async {
    try {
      var result = await _userRepository.getById(userId);

      if (result == null) return Result.error(failureUserNotFound);

      List<Tool> toolsByGiver = await _toolRepository.getByGiver(result.name);
      if (toolsByGiver.isNotEmpty) {
        for (Tool tool in toolsByGiver) {
          await _toolRepository.update(
            Tool(
              id: tool.id,
              name: tool.name,
              date: tool.date,
              giver: updatedUsername,
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
              giver: tool.giver,
              holder: updatedUsername,
              receiver: tool.receiver,
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
              receiver: updatedUsername,
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
