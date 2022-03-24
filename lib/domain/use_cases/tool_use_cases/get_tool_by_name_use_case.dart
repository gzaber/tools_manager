import 'package:async/async.dart';

import '../../../data/models/tool_model.dart';
import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetToolByNameUseCase {
  final IToolRepository _toolRepository;
  GetToolByNameUseCase(this._toolRepository);

  Future<Result<ToolModel>> call(String name) async {
    try {
      Tool? tool = await _toolRepository.getByName(name);

      if (tool == null) return Result.error(failureToolNotFound);

      ToolModel toolModel = ToolModel(
        id: tool.id,
        name: tool.name,
        date: tool.date,
        giver: tool.giver,
        holder: tool.holder,
        receiver: tool.receiver,
      );

      return Result.value(toolModel);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
