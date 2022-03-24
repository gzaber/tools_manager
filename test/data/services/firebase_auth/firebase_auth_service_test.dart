import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/services/firebase_auth/firebase_auth_service.dart';
import 'package:async/async.dart';

void main() {
  late FirebaseAuthService sut;
  late MockFirebaseAuth mockFirebaseAuth;

  group('checkPersistedAuthState', () {
    test('should return user phone number when successful', () {
      // arrange
      final user = MockUser(phoneNumber: '555666777');
      mockFirebaseAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
      sut = FirebaseAuthService(mockFirebaseAuth);
      // act
      var result = sut.checkPersistedAuthState();
      // assert
      expect(result, isNotNull);
      expect(result, '555666777');
    });
    test('should return null when failure', () {
      // arrange
      mockFirebaseAuth = MockFirebaseAuth(mockUser: null, signedIn: false);
      sut = FirebaseAuthService(mockFirebaseAuth);
      // act
      var result = sut.checkPersistedAuthState();
      // assert
      expect(result, isNull);
    });
  });

  group('verifyMobileNumber', () {
    test('firebase_auth_mocks does not support the verifyMobileNumber method currently', () {});
  });

  group('signInWithCredential', () {
    test('should return auth details when successful', () async {
      // arrange
      final user = MockUser(phoneNumber: '555666777');
      mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
      sut = FirebaseAuthService(mockFirebaseAuth);
      // act
      var result = await sut.signInWithCredential('verificationId', '555666777');
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, '555666777');
    });
    test('should return error when failure', () async {
      // arrange
      mockFirebaseAuth = MockFirebaseAuth();
      sut = FirebaseAuthService(mockFirebaseAuth);
      // act
      var result = await sut.signInWithCredential('verificationId', '000000000');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });

  group('signOut', () {
    test('should return true when successful', () async {
      // arrange
      final user = MockUser(phoneNumber: '555666777');
      mockFirebaseAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
      sut = FirebaseAuthService(mockFirebaseAuth);
      // act
      var result = await sut.signOut();
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, true);
    });
  });
}
