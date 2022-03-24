import 'package:async/async.dart';

import '../../../data/models/tool_model.dart';
import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetAllPendingToolsUseCase {
  final IToolRepository _toolRepository;
  GetAllPendingToolsUseCase(this._toolRepository);

  Future<Result<List<ToolModel>>> call() async {
    try {
      List<Tool> pendingTools = await _toolRepository.getPending();

      if (pendingTools.isEmpty) return Result.error(failureNoToolsFound);

      pendingTools.sort((a, b) => a.name.compareTo(b.name));

      List<ToolModel> toolModels = pendingTools
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
