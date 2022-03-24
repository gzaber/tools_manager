import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class GetToolByNameUseCase {
  final IToolRepository _toolRepository;
  GetToolByNameUseCase(this._toolRepository);

  Future<Result<Tool>> call(String name) async {
    try {
      Tool? tool = await _toolRepository.getByName(name);

      if (tool == null) return Result.error(failureToolNotFound);

      return Result.value(tool);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
