import 'package:async/async.dart';

import '../../services/i_auth_service.dart';

class SignOutUseCase {
  final IAuthService _authService;

  SignOutUseCase(this._authService);

  Future<Result<bool>> call() async {
    return await _authService.signOut();
  }
}
