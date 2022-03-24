import 'package:async/async.dart';

import '../../../data/models/tool_model.dart';
import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetToolsByUserUseCase {
  final IToolRepository _toolRepository;
  GetToolsByUserUseCase(this._toolRepository);

  Future<Result<List<ToolModel>>> call(String username) async {
    try {
      List<Tool> toolsByHolder = await _toolRepository.getByHolder(username);
      List<Tool> toolsByReceiver = await _toolRepository.getByReceiver(username);

      List<Tool> tools = List.from(toolsByReceiver)..addAll(toolsByHolder);

      if (tools.isEmpty) return Result.error(failureNoToolsFound);

      tools.sort((a, b) => a.name.compareTo(b.name));

      List<ToolModel> toolModels = tools
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
