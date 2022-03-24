import 'package:async/async.dart';

import '../../repositories/i_tool_repository.dart';

class CountTransferredToolsByUserUseCase {
  final IToolRepository _toolRepository;
  CountTransferredToolsByUserUseCase(this._toolRepository);

  Future<Result<int>> call(String username) async {
    try {
      int counter = await _toolRepository.countTransferredByUser(username);

      return Result.value(counter);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
