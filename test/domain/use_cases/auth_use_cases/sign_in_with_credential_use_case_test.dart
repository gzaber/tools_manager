import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/services/firebase_auth/firebase_auth_service.dart';
import 'package:async/async.dart';
import 'package:tools_manager/domain/use_cases/auth_use_cases/sign_in_with_credential_use_case.dart';

void main() {
  late SignInWithCredentialUseCase sut;
  late FirebaseAuthService firebaseAuthService;
  late MockFirebaseAuth mockFirebaseAuth;

  group('SignInWithCredentialUseCase', () {
    test('should return auth details when successful', () async {
      // arrange
      final user = MockUser(phoneNumber: '555666777');
      mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
      firebaseAuthService = FirebaseAuthService(mockFirebaseAuth);
      sut = SignInWithCredentialUseCase(firebaseAuthService);
      // act
      var result = await sut('verificationId', '555666777');
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, '555666777');
    });

    test('should return error when failure', () async {
      // arrange
      mockFirebaseAuth = MockFirebaseAuth();
      firebaseAuthService = FirebaseAuthService(mockFirebaseAuth);
      sut = SignInWithCredentialUseCase(firebaseAuthService);
      // act
      var result = await sut('verificationId', '000000000');
      // assert
      expect(result.asError, isNotNull);
      expect(result, isA<ErrorResult>());
    });
  });
}
