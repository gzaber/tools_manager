import 'package:async/async.dart';

import '../../../data/models/tool_model.dart';
import '../../entities/tool.dart';
import '../../entities/user.dart';
import '../../repositories/i_tool_repository.dart';
import '../../repositories/i_user_repository.dart';
import '../failure_codes.dart';

class GetToolsInToolRoomUseCase {
  final IToolRepository _toolRepository;
  final IUserRepository _userRepository;
  GetToolsInToolRoomUseCase(this._toolRepository, this._userRepository);

  Future<Result<List<ToolModel>>> call() async {
    try {
      List<Tool> toolRoomTools = [];

      List<User> masters = await _userRepository.getByRole('master');
      if (masters.isNotEmpty) {
        for (User master in masters) {
          var masterTools = await _toolRepository.getInStockByUser(master.name);
          toolRoomTools = List.from(toolRoomTools)..addAll(masterTools);
        }
      }
      List<User> admins = await _userRepository.getByRole('admin');
      if (admins.isNotEmpty) {
        for (User admin in admins) {
          var adminTools = await _toolRepository.getInStockByUser(admin.name);
          toolRoomTools = List.from(toolRoomTools)..addAll(adminTools);
        }
      }

      if (toolRoomTools.isEmpty) return Result.error(failureNoToolsFound);

      toolRoomTools.sort((a, b) => a.name.compareTo(b.name));

      List<ToolModel> toolModels = toolRoomTools
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
