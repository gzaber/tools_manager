import 'package:async/async.dart';

import '../../repositories/i_tool_repository.dart';

class DeleteToolUseCase {
  final IToolRepository _toolRepository;
  DeleteToolUseCase(this._toolRepository);

  Future<Result<void>> call(String id) async {
    try {
      return Result.value(await _toolRepository.delete(id));
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
