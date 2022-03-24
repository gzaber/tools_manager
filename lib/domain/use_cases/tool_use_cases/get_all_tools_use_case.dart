import 'package:async/async.dart';

import '../../../data/models/tool_model.dart';
import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetAllToolsUseCase {
  final IToolRepository _toolRepository;
  GetAllToolsUseCase(this._toolRepository);

  Future<Result<List<ToolModel>>> call() async {
    try {
      List<Tool> tools = await _toolRepository.getAll();

      if (tools.isEmpty) return Result.error(failureNoToolsFound);

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
