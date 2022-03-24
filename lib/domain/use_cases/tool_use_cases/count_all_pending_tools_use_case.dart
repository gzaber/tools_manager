import 'package:async/async.dart';

import '../../repositories/i_tool_repository.dart';

class CountAllPendingToolsUseCase {
  final IToolRepository _toolRepository;
  CountAllPendingToolsUseCase(this._toolRepository);

  Future<Result<int>> call() async {
    try {
      int counter = await _toolRepository.countPending();

      return Result.value(counter);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
