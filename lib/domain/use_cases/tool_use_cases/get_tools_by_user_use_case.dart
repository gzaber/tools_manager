import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetToolsByUserUseCase {
  final IToolRepository _toolRepository;
  GetToolsByUserUseCase(this._toolRepository);

  Future<Result<List<Tool>>> call(String username) async {
    try {
      List<Tool> toolsByHolder = await _toolRepository.getByHolder(username);
      List<Tool> toolsByReceiver =
          await _toolRepository.getByReceiver(username);

      List<Tool> tools = List.from(toolsByReceiver)..addAll(toolsByHolder);

      if (tools.isEmpty) return Result.error(failureNoToolsFound);

      tools.sort((a, b) => a.name.compareTo(b.name));

      return Result.value(tools);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
