import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/services/firebase_auth/firebase_auth_service.dart';
import 'package:tools_manager/domain/services/i_auth_service.dart';
import 'package:tools_manager/domain/use_cases/auth_use_cases/sign_out_use_case.dart';
import 'package:tools_manager/domain/use_cases/common_use_cases/common_use_cases.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/tool_use_cases.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/user_use_cases.dart';

import 'package:tools_manager/presentation/states_management/home_cubit/home_cubit.dart';

import '../../../fake_repositories/fake_tool_repository.dart';
import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late HomeCubit sut;
  late SignOutUseCase signOutUseCase;
  late IAuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late CountToolsInStockByUserUseCase countToolsInStockByUserUseCase;
  late CountTransferredToolsByUserUseCase countTransferredToolsByUserUseCase;
  late CountReceivedToolsByUserUseCase countReceivedToolsByUserUseCase;
  late CountToolsInToolRoomUseCase countToolsInToolRoomUseCase;
  late CountToolsAtUsersUseCase countToolsAtUsersUseCase;
  late CountAllPendingToolsUseCase countAllPendingToolsUseCase;
  late CountUsersByRoleUseCase countUsersByRoleUseCase;
  late FakeToolRepository fakeToolRepository;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    fakeUserRepository = FakeUserRepository();
    mockFirebaseAuth = MockFirebaseAuth();
    authService = FirebaseAuthService(mockFirebaseAuth);
    signOutUseCase = SignOutUseCase(authService);
    countToolsInStockByUserUseCase = CountToolsInStockByUserUseCase(fakeToolRepository);
    countTransferredToolsByUserUseCase = CountTransferredToolsByUserUseCase(fakeToolRepository);
    countReceivedToolsByUserUseCase = CountReceivedToolsByUserUseCase(fakeToolRepository);
    countToolsInToolRoomUseCase =
        CountToolsInToolRoomUseCase(fakeToolRepository, fakeUserRepository);
    countToolsAtUsersUseCase = CountToolsAtUsersUseCase(fakeToolRepository, fakeUserRepository);
    countAllPendingToolsUseCase = CountAllPendingToolsUseCase(fakeToolRepository);
    countUsersByRoleUseCase = CountUsersByRoleUseCase(fakeUserRepository);
    sut = HomeCubit(
      signOutUseCase,
      countToolsInStockByUserUseCase,
      countTransferredToolsByUserUseCase,
      countReceivedToolsByUserUseCase,
      countToolsInToolRoomUseCase,
      countToolsAtUsersUseCase,
      countAllPendingToolsUseCase,
      countUsersByRoleUseCase,
    );
  });

  group('initial state', () {
    test('state equals HomeInitial() when initial state', () {
      // assert
      expect(sut.state, HomeInitial());
    });

    blocTest<HomeCubit, HomeState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('signOut', () {
    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading, HomeSignOutSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.signOut(),
      expect: () => [HomeLoading(), isA<HomeSignOutSuccess>()],
    );
  });

  group('getInfo', () {
    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading, HomeLoadSuccess] when users and tools found',
      build: () => sut,
      act: (cubit) => cubit.getInfo('holder1'),
      expect: () => [HomeLoading(), isA<HomeLoadSuccess>()],
    );
    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading, HomeLoadSuccess] when users and tools not found',
      setUp: () {
        fakeUserRepository.users.clear();
        fakeToolRepository.tools.clear();
      },
      build: () => sut,
      act: (cubit) => cubit.getInfo('user1'),
      expect: () => [HomeLoading(), isA<HomeLoadSuccess>()],
    );
    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading, HomeFailure] when exception occured',
      build: () => sut,
      act: (cubit) => cubit.getInfo('exception'),
      expect: () => [HomeLoading(), isA<HomeFailure>()],
    );
  });
}
