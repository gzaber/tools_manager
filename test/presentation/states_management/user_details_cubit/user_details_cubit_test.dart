import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/get_tools_by_user_use_case.dart';
import 'package:tools_manager/presentation/states_management/user_details_cubit/user_details_cubit.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late UserDetailsCubit sut;
  late GetToolsByUserUseCase getToolsByUserUseCase;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    getToolsByUserUseCase = GetToolsByUserUseCase(fakeToolRepository);
    sut = UserDetailsCubit(getToolsByUserUseCase);
  });

  group('initial state', () {
    test('state equals UserDetailsInitial() when initial state', () {
      // assert
      expect(sut.state, UserDetailsInitial());
    });
    blocTest<UserDetailsCubit, UserDetailsState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('getUserTools', () {
    blocTest<UserDetailsCubit, UserDetailsState>(
      'emits [UserDetailsLoading, UserDetailsLoadSuccess] when tools found',
      build: () => sut,
      act: (cubit) => cubit.getUserTools('user1'),
      expect: () => [UserDetailsLoading(), isA<UserDetailsLoadSuccess>()],
    );
    blocTest<UserDetailsCubit, UserDetailsState>(
      'emits [UserDetailsLoading, UserDetailsFailure] when no tools found',
      setUp: () => fakeToolRepository.tools.clear(),
      build: () => sut,
      act: (cubit) => cubit.getUserTools('wrongUser'),
      expect: () => [UserDetailsLoading(), isA<UserDetailsFailure>()],
    );
  });
}
