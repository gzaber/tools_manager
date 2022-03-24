import 'package:async/async.dart';

import '../../services/i_auth_service.dart';

class SignInWithCredentialUseCase {
  final IAuthService _authService;

  SignInWithCredentialUseCase(this._authService);

  Future<Result<String>> call(String verificationId, String smsCode) async {
    return await _authService.signInWithCredential(verificationId, smsCode);
  }
}
