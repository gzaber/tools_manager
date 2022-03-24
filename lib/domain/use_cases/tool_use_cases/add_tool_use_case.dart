import 'package:async/async.dart';

import '../../entities/tool.dart';
import '../../repositories/i_tool_repository.dart';
import '../failure_codes.dart';

class AddToolUseCase {
  final IToolRepository _toolRepository;

  AddToolUseCase(this._toolRepository);

  Future<Result<void>> call(String name, String date, String holder) async {
    try {
      if (name.isEmpty) return Result.error(failureToolnameEmpty);
      var result = await _toolRepository.getByName(name);
      if (result != null) return Result.error(failureToolnameExists);

      Tool tool = Tool(
        name: name,
        date: date,
        holder: holder,
      );
      return Result.value(await _toolRepository.add(tool));
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
