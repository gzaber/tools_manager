import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/get_all_users_use_case.dart';
import 'package:tools_manager/presentation/states_management/transfer_tool_cubit/transfer_tool_cubit.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late TransferToolCubit sut;
  late GetAllUsersUseCase getAllUsersUseCase;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
    getAllUsersUseCase = GetAllUsersUseCase(fakeUserRepository);
    sut = TransferToolCubit(getAllUsersUseCase);
  });

  group('initial state', () {
    test('state equals TransferToolInitial() when initial state', () {
      // assert
      expect(sut.state, TransferToolInitial());
    });
    blocTest<TransferToolCubit, TransferToolState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('getAllUsers', () {
    blocTest<TransferToolCubit, TransferToolState>(
      'emits [TransferToolLoading, TransferToolLoadSuccess] when users found',
      build: () => sut,
      act: (cubit) => cubit.getAllUsers(),
      expect: () => [TransferToolLoading(), isA<TransferToolLoadSuccess>()],
    );
    blocTest<TransferToolCubit, TransferToolState>(
      'emits [TransferToolLoading, TransferToolFailure] when no users found',
      setUp: () => fakeUserRepository.users.clear(),
      build: () => sut,
      act: (cubit) => cubit.getAllUsers(),
      expect: () => [TransferToolLoading(), isA<TransferToolFailure>()],
    );
  });
}
