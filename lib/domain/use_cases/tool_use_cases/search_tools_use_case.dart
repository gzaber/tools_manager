import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class SearchToolsUseCase {
  final IToolRepository _toolRepository;
  SearchToolsUseCase(this._toolRepository);

  Future<Result<List<Tool>>> call(String name) async {
    try {
      List<Tool> tools = await _toolRepository.searchByName(name);

      if (tools.isEmpty) return Result.error(failureNoToolsFound);

      return Result.value(tools);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
