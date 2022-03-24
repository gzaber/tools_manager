import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/models/tool_model.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/tool_use_cases.dart';
import 'package:tools_manager/presentation/states_management/tool_details_cubit/tool_details_cubit.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late ToolDetailsCubit sut;
  late GetToolByIdUseCase getToolByIdUseCase;
  late UpdateToolUseCase updateToolUseCase;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    getToolByIdUseCase = GetToolByIdUseCase(fakeToolRepository);
    updateToolUseCase = UpdateToolUseCase(fakeToolRepository);
    sut = ToolDetailsCubit(getToolByIdUseCase, updateToolUseCase);
  });

  group('initial state', () {
    test('states equals ToolDetailsInitial() when initial state', () {
      // assert
      expect(sut.state, ToolDetailsInitial());
    });
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('getToolById', () {
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsLoadSuccess] when tool found',
      build: () => sut,
      act: (cubit) => cubit.getToolById('11'),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsLoadSuccess>()],
    );
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsFailure] when tool not found',
      setUp: () => fakeToolRepository.tools.clear(),
      build: () => sut,
      act: (cubit) => cubit.getToolById('unknownId'),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsFailure>()],
    );
  });

  group('returnTool', () {
    late ToolModel toolModel;
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsLoadSuccess] when successful',
      setUp: () {
        toolModel = ToolModel(
            id: fakeToolRepository.tools.first.id,
            name: 'name1',
            date: '2022',
            giver: 'giver1',
            holder: 'user1');
      },
      build: () => sut,
      act: (cubit) => cubit.returnTool(toolModel),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsLoadSuccess>()],
    );
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsFailure] when failure',
      setUp: () {
        toolModel = ToolModel(
          id: 'wrongId',
          name: 'name1',
          date: '2022',
          giver: 'giver1',
          holder: 'user1',
        );
      },
      build: () => sut,
      act: (cubit) => cubit.returnTool(toolModel),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsFailure>()],
    );
  });
  group('confirm', () {
    late ToolModel toolModel;
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsLoadSuccess] when successful',
      setUp: () {
        toolModel = ToolModel(
          id: fakeToolRepository.tools.first.id,
          name: 'name1',
          date: '2022',
          giver: 'giver1',
          holder: 'user1',
          receiver: 'user2',
        );
      },
      build: () => sut,
      act: (cubit) => cubit.confirm(toolModel),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsLoadSuccess>()],
    );
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsFailure] when failure',
      setUp: () {
        toolModel = ToolModel(
          id: 'wrongId',
          name: 'name1',
          date: '2022',
          giver: 'giver1',
          holder: 'user1',
          receiver: 'user2',
        );
      },
      build: () => sut,
      act: (cubit) => cubit.confirm(toolModel),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsFailure>()],
    );
  });
  group('cancel', () {
    late ToolModel toolModel;
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsLoadSuccess] when successful',
      setUp: () {
        toolModel = ToolModel(
          id: fakeToolRepository.tools.first.id,
          name: 'name1',
          date: '2022',
          giver: 'giver1',
          holder: 'user1',
          receiver: 'user2',
        );
      },
      build: () => sut,
      act: (cubit) => cubit.cancel(toolModel),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsLoadSuccess>()],
    );
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsFailure] when failure',
      setUp: () {
        toolModel = ToolModel(
          id: 'wrongId',
          name: 'name1',
          date: '2022',
          giver: 'giver1',
          holder: 'user1',
          receiver: 'user2',
        );
      },
      build: () => sut,
      act: (cubit) => cubit.cancel(toolModel),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsFailure>()],
    );
  });
  group('transfer', () {
    late ToolModel toolModel;
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsLoadSuccess] when successful',
      setUp: () {
        toolModel = ToolModel(
          id: fakeToolRepository.tools.first.id,
          name: 'name1',
          date: '2022',
          giver: 'giver1',
          holder: 'user1',
          receiver: 'user2',
        );
      },
      build: () => sut,
      act: (cubit) => cubit.transfer(toolModel, 'receiver'),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsLoadSuccess>()],
    );
    blocTest<ToolDetailsCubit, ToolDetailsState>(
      'emits [ToolDetailsLoading, ToolDetailsFailure] when failure',
      setUp: () {
        toolModel = ToolModel(
          id: 'wrongId',
          name: 'name1',
          date: '2022',
          giver: 'giver1',
          holder: 'user1',
          receiver: 'user2',
        );
      },
      build: () => sut,
      act: (cubit) => cubit.transfer(toolModel, 'receiver'),
      expect: () => [ToolDetailsLoading(), isA<ToolDetailsFailure>()],
    );
  });
}
