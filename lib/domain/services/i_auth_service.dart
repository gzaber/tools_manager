import 'package:async/async.dart';

abstract class IAuthService {
  String? checkPersistedAuthState();
  Future<Result<String>> verifyMobileNumber(String mobileNumber);
  Future<Result<String>> signInWithCredential(String verificationId, String smsCode);
  Future<Result<bool>> signOut();
}
