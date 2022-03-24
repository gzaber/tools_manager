import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/models/user_model.dart';
import 'package:tools_manager/domain/use_cases/common_use_cases/common_use_cases.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/tool_use_cases.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/user_use_cases.dart';
import 'package:tools_manager/presentation/states_management/users_cubit/users_cubit.dart';

import '../../../fake_repositories/fake_tool_repository.dart';
import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late UsersCubit sut;
  late GetAllUsersUseCase getAllUsersUseCase;
  late CountToolsInStockByUserUseCase countToolsInStockByUserUseCase;
  late CountTransferredToolsByUserUseCase countTransferredToolsByUserUseCase;
  late CountReceivedToolsByUserUseCase countReceivedToolsByUserUseCase;
  late AddUserUseCase addUserUseCase;
  late UpdateUserUseCase updateUserUseCase;
  late DeleteUserUseCase deleteUserUseCase;
  late UpdateToolsByUserIdUseCase updateToolsByUserIdUseCase;
  late MoveDeletedUserToolsUseCase moveDeletedUserToolsUseCase;
  late FakeUserRepository fakeUserRepository;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
    fakeToolRepository = FakeToolRepository();
    getAllUsersUseCase = GetAllUsersUseCase(fakeUserRepository);
    countToolsInStockByUserUseCase = CountToolsInStockByUserUseCase(fakeToolRepository);
    countTransferredToolsByUserUseCase = CountTransferredToolsByUserUseCase(fakeToolRepository);
    countReceivedToolsByUserUseCase = CountReceivedToolsByUserUseCase(fakeToolRepository);
    addUserUseCase = AddUserUseCase(fakeUserRepository);
    updateUserUseCase = UpdateUserUseCase(fakeUserRepository);
    deleteUserUseCase = DeleteUserUseCase(fakeUserRepository);
    updateToolsByUserIdUseCase = UpdateToolsByUserIdUseCase(fakeToolRepository, fakeUserRepository);
    moveDeletedUserToolsUseCase =
        MoveDeletedUserToolsUseCase(fakeToolRepository, fakeUserRepository);
    sut = UsersCubit(
      getAllUsersUseCase,
      countToolsInStockByUserUseCase,
      countTransferredToolsByUserUseCase,
      countReceivedToolsByUserUseCase,
      addUserUseCase,
      updateUserUseCase,
      deleteUserUseCase,
      updateToolsByUserIdUseCase,
      moveDeletedUserToolsUseCase,
    );
  });

  group('initial state', () {
    test('state equals UsersInitial() when initial state', () {
      // assert
      expect(sut.state, UsersInitial());
    });
    blocTest<UsersCubit, UsersState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('getInfo', () {
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersLoadSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.getInfo(),
      expect: () => [UsersLoading(), isA<UsersLoadSuccess>()],
    );
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersFailure] when no users found',
      setUp: () => fakeUserRepository.users.clear(),
      build: () => sut,
      act: (cubit) => cubit.getInfo(),
      expect: () => [UsersLoading(), isA<UsersFailure>()],
    );
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersLoadSuccess] when users found but no tools found',
      setUp: () => fakeToolRepository.tools.clear(),
      build: () => sut,
      act: (cubit) => cubit.getInfo(),
      expect: () => [UsersLoading(), isA<UsersLoadSuccess>()],
    );
  });

  group('addUser', () {
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersManageUserSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.addUser('username', '666555444', 'user'),
      expect: () => [UsersLoading(), isA<UsersManageUserSuccess>()],
    );
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersManageUserFailure] when failure',
      setUp: () => fakeUserRepository.users.clear(),
      build: () => sut,
      act: (cubit) => cubit.addUser('', '666555444', 'user'),
      expect: () => [UsersLoading(), isA<UsersManageUserFailure>()],
    );
  });

  group('updateUser', () {
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersManageUserSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.updateUser(
        UserModel(
          id: fakeUserRepository.users.first.id,
          name: fakeUserRepository.users.first.name,
          mobileNumber: '666555444',
          role: 'user',
        ),
      ),
      expect: () => [UsersLoading(), isA<UsersManageUserSuccess>()],
    );
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersManageUserFailure] when failure',
      build: () => sut,
      act: (cubit) => cubit.updateUser(
        UserModel(
          id: fakeUserRepository.users.first.id,
          name: 'user',
          mobileNumber: fakeUserRepository.users.last.mobileNumber,
          role: 'user',
        ),
      ),
      expect: () => [UsersLoading(), isA<UsersManageUserFailure>()],
    );
  });

  group('deleteUser', () {
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersManageUserSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.deleteUser(fakeUserRepository.users.first.id!, 'targetUsername'),
      expect: () => [UsersLoading(), isA<UsersManageUserSuccess>()],
    );
    blocTest<UsersCubit, UsersState>(
      'emits [UsersLoading, UsersManageUserFailure] when failure',
      build: () => sut,
      act: (cubit) => cubit.deleteUser('wrongId', 'targetUsername'),
      expect: () => [UsersLoading(), isA<UsersManageUserFailure>()],
    );
  });
}
