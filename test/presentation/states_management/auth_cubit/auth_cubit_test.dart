import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/services/firebase_auth/firebase_auth_service.dart';
import 'package:tools_manager/domain/services/i_auth_service.dart';
import 'package:tools_manager/domain/use_cases/auth_use_cases/check_persisted_auth_state_use_case.dart';
import 'package:tools_manager/domain/use_cases/auth_use_cases/sign_in_with_credential_use_case.dart';
import 'package:tools_manager/domain/use_cases/auth_use_cases/verify_mobile_number_use_case.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/get_user_by_mobile_number_use_case.dart';
import 'package:tools_manager/presentation/states_management/auth_cubit/auth_cubit.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late AuthCubit sut;
  late CheckPersistedAuthStateUseCase checkPersistedAuthStateUseCase;
  late VerifyMobileNumberUseCase verifyMobileNumberUseCase;
  late SignInWithCredentialUseCase signInWithCredentialUseCase;
  late GetUserByMobileNumberUseCase getUserByMobileNumberUseCase;
  late FakeUserRepository fakeUserRepository;
  late IAuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = FirebaseAuthService(mockFirebaseAuth);
    fakeUserRepository = FakeUserRepository();
    getUserByMobileNumberUseCase = GetUserByMobileNumberUseCase(fakeUserRepository);
    signInWithCredentialUseCase = SignInWithCredentialUseCase(authService);
    verifyMobileNumberUseCase = VerifyMobileNumberUseCase(authService, fakeUserRepository);
    checkPersistedAuthStateUseCase =
        CheckPersistedAuthStateUseCase(authService, fakeUserRepository);
    sut = AuthCubit(
      checkPersistedAuthStateUseCase,
      verifyMobileNumberUseCase,
      signInWithCredentialUseCase,
      getUserByMobileNumberUseCase,
    );
  });

  group('initial state', () {
    test('state equals HomeInitial() when initial state', () {
      // assert
      expect(sut.state, AuthInitial());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('checkPersistedAuthState', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSignInSuccess] when successful',
      setUp: () {
        final user = MockUser(phoneNumber: fakeUserRepository.users.first.mobileNumber);
        mockFirebaseAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
        authService = FirebaseAuthService(mockFirebaseAuth);
        checkPersistedAuthStateUseCase =
            CheckPersistedAuthStateUseCase(authService, fakeUserRepository);
        sut = AuthCubit(
          checkPersistedAuthStateUseCase,
          verifyMobileNumberUseCase,
          signInWithCredentialUseCase,
          getUserByMobileNumberUseCase,
        );
      },
      build: () => sut,
      act: (cubit) => cubit.checkPersistedAuthState(),
      expect: () => [AuthLoading(), isA<AuthSignInSuccess>()],
    );
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthPersistenceFailure] when failure',
      build: () => sut,
      act: (cubit) => cubit.checkPersistedAuthState(),
      expect: () => [AuthLoading(), isA<AuthPersistenceFailure>()],
    );
  });

  group('verifyMobileNumber', () {
    test('firebase_auth_mocks does not support the verifyMobileNumber method currently', () {});
  });

  group('signInWithCredential', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSignInSuccess] when successful',
      setUp: () {
        final user = MockUser(phoneNumber: fakeUserRepository.users.first.mobileNumber);
        mockFirebaseAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
        authService = FirebaseAuthService(mockFirebaseAuth);
        signInWithCredentialUseCase = SignInWithCredentialUseCase(authService);
        sut = AuthCubit(
          checkPersistedAuthStateUseCase,
          verifyMobileNumberUseCase,
          signInWithCredentialUseCase,
          getUserByMobileNumberUseCase,
        );
      },
      build: () => sut,
      act: (cubit) => cubit.signInWithCredential(
          'verificationId', 'smsCode', fakeUserRepository.users.first.mobileNumber),
      expect: () => [AuthLoading(), isA<AuthSignInSuccess>()],
    );
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailure] when failure',
      build: () => sut,
      act: (cubit) => cubit.signInWithCredential('verificationId', 'smsCode', '000000000'),
      expect: () => [AuthLoading(), isA<AuthFailure>()],
    );
  });
}
