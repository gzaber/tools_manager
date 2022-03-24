import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/common_use_cases/common_use_cases.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/tool_use_cases.dart';
import 'package:tools_manager/presentation/states_management/tool_room_cubit/tool_room_cubit.dart';

import '../../../fake_repositories/fake_tool_repository.dart';
import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late ToolRoomCubit sut;
  late GetToolsInToolRoomUseCase getToolsInToolRoomUseCase;
  late GetToolsAtUsersUseCase getToolsAtUsersUseCase;
  late GetAllPendingToolsUseCase getAllPendingToolsUseCase;
  late FakeToolRepository fakeToolRepository;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    fakeUserRepository = FakeUserRepository();
    getToolsInToolRoomUseCase = GetToolsInToolRoomUseCase(fakeToolRepository, fakeUserRepository);
    getToolsAtUsersUseCase = GetToolsAtUsersUseCase(fakeToolRepository, fakeUserRepository);
    getAllPendingToolsUseCase = GetAllPendingToolsUseCase(fakeToolRepository);
    sut =
        ToolRoomCubit(getToolsInToolRoomUseCase, getToolsAtUsersUseCase, getAllPendingToolsUseCase);
  });

  group('initial state', () {
    test('states equals ToolRoomInitial() when initial state', () {
      // assert
      expect(sut.state, ToolRoomInitial());
    });
    blocTest<ToolRoomCubit, ToolRoomState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('getInToolRoom', () {
    blocTest<ToolRoomCubit, ToolRoomState>(
      'emits [ToolRoomLoading, ToolRoomLoadSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.getInToolRoom(),
      expect: () => [ToolRoomLoading(), isA<ToolRoomLoadSuccess>()],
    );
    blocTest<ToolRoomCubit, ToolRoomState>(
      'emits [ToolRoomLoading, ToolRoomFailure] when no tools found',
      setUp: () => fakeToolRepository.tools.clear(),
      build: () => sut,
      act: (cubit) => cubit.getInToolRoom(),
      expect: () => [ToolRoomLoading(), isA<ToolRoomFailure>()],
    );
  });

  group('getAtUsers', () {
    blocTest<ToolRoomCubit, ToolRoomState>(
      'emits [ToolRoomLoading, ToolRoomLoadSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.getAtUsers(),
      expect: () => [ToolRoomLoading(), isA<ToolRoomLoadSuccess>()],
    );
    blocTest<ToolRoomCubit, ToolRoomState>(
      'emits [ToolRoomLoading, ToolRoomFailure] when no tools found',
      setUp: () => fakeToolRepository.tools.clear(),
      build: () => sut,
      act: (cubit) => cubit.getAtUsers(),
      expect: () => [ToolRoomLoading(), isA<ToolRoomFailure>()],
    );
  });

  group('getPending', () {
    blocTest<ToolRoomCubit, ToolRoomState>(
      'emits [ToolRoomLoading, ToolRoomLoadSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.getPending(),
      expect: () => [ToolRoomLoading(), isA<ToolRoomLoadSuccess>()],
    );
    blocTest<ToolRoomCubit, ToolRoomState>(
      'emits [ToolRoomLoading, ToolRoomFailure] when no tools found',
      setUp: () => fakeToolRepository.tools.clear(),
      build: () => sut,
      act: (cubit) => cubit.getPending(),
      expect: () => [ToolRoomLoading(), isA<ToolRoomFailure>()],
    );
  });
}
