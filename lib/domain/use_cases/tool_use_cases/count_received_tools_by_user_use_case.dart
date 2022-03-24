import 'package:async/async.dart';

import '../../repositories/i_tool_repository.dart';

class CountReceivedToolsByUserUseCase {
  final IToolRepository _toolRepository;
  CountReceivedToolsByUserUseCase(this._toolRepository);

  Future<Result<int>> call(String username) async {
    try {
      int counter = await _toolRepository.countReceivedByUser(username);

      return Result.value(counter);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
