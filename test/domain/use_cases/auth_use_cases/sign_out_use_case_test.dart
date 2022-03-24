import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/services/firebase_auth/firebase_auth_service.dart';
import 'package:tools_manager/domain/use_cases/auth_use_cases/sign_out_use_case.dart';
import 'package:async/async.dart';

void main() {
  late SignOutUseCase sut;
  late FirebaseAuthService firebaseAuthService;
  late MockFirebaseAuth mockFirebaseAuth;

  group('SignOutUseCase', () {
    test('should return true when successful', () async {
      // arrange
      final user = MockUser(phoneNumber: '555666777');
      mockFirebaseAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
      firebaseAuthService = FirebaseAuthService(mockFirebaseAuth);
      sut = SignOutUseCase(firebaseAuthService);
      // act
      var result = await sut();
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, true);
    });
  });
}
