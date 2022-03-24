import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/services/i_auth_service.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  //================================================================================================
  @override
  String? checkPersistedAuthState() {
    var currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      return currentUser.phoneNumber;
    } else {
      return null;
    }
  }

  //================================================================================================
  @override
  Future<Result<String>> verifyMobileNumber(String mobileNumber) async {
    String _verificationError = '';
    String _verificationId = '';

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: (credential) {
        _verificationId = credential.verificationId ?? '';
      },
      verificationFailed: (e) {
        _verificationError = e.toString();
      },
      codeSent: (String verificationId, _) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    while (_verificationId.isEmpty && _verificationError.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
    }

    if (_verificationError.isNotEmpty) return Result.error(_verificationError);
    return Result.value(_verificationId);
  }

  //================================================================================================
  @override
  Future<Result<String>> signInWithCredential(String verificationId, String smsCode) async {
    try {
      var result = await _firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode),
      );
      return Result.value(result.user!.phoneNumber!);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  //================================================================================================
  @override
  Future<Result<bool>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Result.value(true);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  //================================================================================================
}
