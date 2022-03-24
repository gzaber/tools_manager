import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/search_tools_use_case.dart';
import 'package:tools_manager/presentation/states_management/search_tools_cubit/search_tools_cubit.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late SearchToolsCubit sut;
  late SearchToolsUseCase searchToolsUseCase;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    searchToolsUseCase = SearchToolsUseCase(fakeToolRepository);
    sut = SearchToolsCubit(searchToolsUseCase);
  });

  group('initial state', () {
    test('state equals SearchToolsInitial() when initial state', () {
      // assert
      expect(sut.state, SearchToolsInitial());
    });
    blocTest<SearchToolsCubit, SearchToolsState>(
      'emits [] when nothing was done',
      build: () => sut,
      expect: () => [],
    );
  });

  group('searchToolsByName', () {
    blocTest<SearchToolsCubit, SearchToolsState>(
      'emits [SearchToolsLoading, SearchToolsLoadSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.searchToolsByName('name'),
      expect: () => [SearchToolsLoading(), isA<SearchToolsLoadSuccess>()],
    );
    blocTest<SearchToolsCubit, SearchToolsState>(
      'emits [SearchToolsLoading, SearchToolsFailure] when no tools found',
      build: () => sut,
      act: (cubit) => cubit.searchToolsByName('unknownName'),
      expect: () => [SearchToolsLoading(), isA<SearchToolsFailure>()],
    );
  });

  group('clearSearchResults', () {
    blocTest<SearchToolsCubit, SearchToolsState>(
      'emits [SearchToolsLoading, SearchToolsLoadSuccess] when successful',
      build: () => sut,
      act: (cubit) => cubit.clearSearchResults(),
      expect: () => [SearchToolsLoading(), isA<SearchToolsLoadSuccess>()],
    );
  });
}
