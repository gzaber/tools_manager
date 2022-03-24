import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetAllPendingToolsUseCase {
  final IToolRepository _toolRepository;
  GetAllPendingToolsUseCase(this._toolRepository);

  Future<Result<List<Tool>>> call() async {
    try {
      List<Tool> pendingTools = await _toolRepository.getPending();

      if (pendingTools.isEmpty) return Result.error(failureNoToolsFound);

      pendingTools.sort((a, b) => a.name.compareTo(b.name));

      return Result.value(pendingTools);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
