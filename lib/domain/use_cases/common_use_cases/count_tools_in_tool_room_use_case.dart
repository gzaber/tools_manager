import 'package:async/async.dart';

import '../../entities/user.dart';
import '../../repositories/i_tool_repository.dart';
import '../../repositories/i_user_repository.dart';

class CountToolsInToolRoomUseCase {
  final IToolRepository _toolRepository;
  final IUserRepository _userRepository;
  CountToolsInToolRoomUseCase(this._toolRepository, this._userRepository);

  Future<Result<int>> call() async {
    try {
      int toolsCounter = 0;

      List<User> masters = await _userRepository.getByRole('master');
      if (masters.isNotEmpty) {
        for (User master in masters) {
          int masterToolsCounter = await _toolRepository.countInStockByUser(master.name);
          toolsCounter += masterToolsCounter;
        }
      }
      List<User> admins = await _userRepository.getByRole('admin');
      if (admins.isNotEmpty) {
        for (User admin in admins) {
          int adminToolsCounter = await _toolRepository.countInStockByUser(admin.name);
          toolsCounter += adminToolsCounter;
        }
      }

      return Result.value(toolsCounter);
    } catch (err) {
      return Result.error(err.toString());
    }
  }
}
