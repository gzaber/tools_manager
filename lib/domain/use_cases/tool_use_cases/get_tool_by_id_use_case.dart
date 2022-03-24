import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetToolByIdUseCase {
  final IToolRepository _toolRepository;
  GetToolByIdUseCase(this._toolRepository);

  Future<Result<Tool>> call(String id) async {
    try {
      Tool? tool = await _toolRepository.getById(id);

      if (tool == null) return Result.error(failureToolNotFound);

      return Result.value(tool);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
