import 'package:async/async.dart';

import '../../../data/models/tool_model.dart';
import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class UpdateToolUseCase {
  final IToolRepository _toolRepository;
  UpdateToolUseCase(this._toolRepository);

  Future<Result<void>> call(ToolModel toolModel) async {
    try {
      if (toolModel.name.isEmpty) return Result.error(failureToolnameEmpty);
      var result = await _toolRepository.getByName(toolModel.name);
      if (result != null && result.id != toolModel.id) {
        return Result.error(failureToolnameExists);
      }

      Tool tool = Tool(
        id: toolModel.id,
        name: toolModel.name,
        date: toolModel.date,
        giver: toolModel.giver,
        holder: toolModel.holder,
        receiver: toolModel.receiver,
      );

      return Result.value(await _toolRepository.update(tool));
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
