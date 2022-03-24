import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/services/firebase_auth/firebase_auth_service.dart';
import 'package:tools_manager/domain/entities/user.dart';
import 'package:tools_manager/domain/use_cases/auth_use_cases/check_persisted_auth_state_use_case.dart';
import 'package:async/async.dart';
import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late CheckPersistedAuthStateUseCase sut;
  late FirebaseAuthService firebaseAuthService;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
  });

  group('CheckPersistedAuthStateUseCase', () {
    test('should return User when successful', () async {
      // arrange
      final user =
          MockUser(phoneNumber: fakeUserRepository.users.first.mobileNumber);
      mockFirebaseAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
      firebaseAuthService = FirebaseAuthService(mockFirebaseAuth);
      sut = CheckPersistedAuthStateUseCase(
          firebaseAuthService, fakeUserRepository);
      // act
      var result = await sut();
      // assert
      expect(result.asValue, isNotNull);
      expect(result.asValue!.value, isA<User>());
    });
    test('should return error when failure', () async {
      // arrange
      mockFirebaseAuth = MockFirebaseAuth();
      firebaseAuthService = FirebaseAuthService(mockFirebaseAuth);
      sut = CheckPersistedAuthStateUseCase(
          firebaseAuthService, fakeUserRepository);
      // act
      var result = await sut();
      // assert
      expect(result.asError, isNotNull);
      expect(result, isA<ErrorResult>());
    });
  });
}
