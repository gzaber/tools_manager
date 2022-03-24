import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/models/tool_model.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/tool_use_cases.dart';
import 'package:tools_manager/presentation/states_management/toolbox_cubit/toolbox_cubit.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late ToolboxCubit sut;
  late GetToolsByUserUseCase getToolsByUserUseCase;
  late AddToolUseCase addToolUseCase;
  late UpdateToolUseCase updateToolUseCase;
  late DeleteToolUseCase deleteToolUseCase;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    getToolsByUserUseCase = GetToolsByUserUseCase(fakeToolRepository);
    addToolUseCase = AddToolUseCase(fakeToolRepository);
    updateToolUseCase = UpdateToolUseCase(fakeToolRepository);
    deleteToolUseCase = DeleteToolUseCase(fakeToolRepository);
    sut = ToolboxCubit(getToolsByUserUseCase, addToolUseCase, updateToolUseCase, deleteToolUseCase);
  });

  group('initial state', () {
    test('state equals ToolboxInitial() when initial state', () {
      // assert
      expect(sut.state, ToolboxInitial());
    });
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('getTools', () {
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [ToolboxLoading, ToolboxLoadSuccess] when found tools',
      build: () => sut,
      act: (cubit) => cubit.getTools('user1'),
      expect: () => [ToolboxLoading(), isA<ToolboxLoadSuccess>()],
    );
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [ToolboxLoading, ToolboxFailure] when no tools found',
      setUp: () => fakeToolRepository.tools.clear(),
      build: () => sut,
      act: (cubit) => cubit.getTools('wrongUsername'),
      expect: () => [ToolboxLoading(), isA<ToolboxLoadFailure>()],
    );
  });

  group('addTool', () {
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [ToolboxLoading, ToolboxManageToolSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.addTool('toolName', '2022', 'user1'),
      expect: () => [ToolboxLoading(), isA<ToolboxManageToolSuccess>()],
    );
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [ToolboxLoading, ToolboxManageToolFailure] when failure',
      build: () => sut,
      act: (cubit) => cubit.addTool('', '2022', 'user1'),
      expect: () => [ToolboxLoading(), isA<ToolboxManageToolFailure>()],
    );
  });

  group('updateTool', () {
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [ToolboxLoading, ToolboxManageToolSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.updateTool(ToolModel(
          id: fakeToolRepository.tools.first.id, name: 'toolName', date: '2022', holder: 'user1')),
      expect: () => [ToolboxLoading(), isA<ToolboxManageToolSuccess>()],
    );
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [ToolboxLoading, ToolboxManageToolFailure] when failure',
      build: () => sut,
      act: (cubit) => cubit.updateTool(ToolModel(name: '', date: '2022', holder: 'user1')),
      expect: () => [ToolboxLoading(), isA<ToolboxManageToolFailure>()],
    );
  });

  group('deleteTool', () {
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [ToolboxLoading, ToolboxManageToolSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.deleteTool(fakeToolRepository.tools.first.id!),
      expect: () => [ToolboxLoading(), isA<ToolboxManageToolSuccess>()],
    );
    blocTest<ToolboxCubit, ToolboxState>(
      'emits [ToolboxLoading, ToolboxManageToolFailure] when failure',
      build: () => sut,
      act: (cubit) => cubit.deleteTool('wrongId'),
      expect: () => [ToolboxLoading(), isA<ToolboxManageToolFailure>()],
    );
  });
}
