import 'package:async/async.dart';

import '../../repositories/i_tool_repository.dart';

class CountToolsInStockByUserUseCase {
  final IToolRepository _toolRepository;
  CountToolsInStockByUserUseCase(this._toolRepository);

  Future<Result<int>> call(String username) async {
    try {
      int counter = await _toolRepository.countInStockByUser(username);

      return Result.value(counter);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
