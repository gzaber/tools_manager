import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class UpdateToolUseCase {
  final IToolRepository _toolRepository;
  UpdateToolUseCase(this._toolRepository);

  Future<Result<void>> call(Tool tool) async {
    try {
      if (tool.name.isEmpty) return Result.error(failureToolnameEmpty);
      var result = await _toolRepository.getByName(tool.name);
      if (result != null && result.id != tool.id) {
        return Result.error(failureToolnameExists);
      }

      return Result.value(await _toolRepository.update(tool));
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
