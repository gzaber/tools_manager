import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetAllToolsUseCase {
  final IToolRepository _toolRepository;
  GetAllToolsUseCase(this._toolRepository);

  Future<Result<List<Tool>>> call() async {
    try {
      List<Tool> tools = await _toolRepository.getAll();

      if (tools.isEmpty) return Result.error(failureNoToolsFound);

      return Result.value(tools);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
