import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/count_all_pending_tools_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late CountAllPendingToolsUseCase sut;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    sut = CountAllPendingToolsUseCase(fakeToolRepository);
  });

  group('CountPendingToolsUseCase', () {
    test('should return number of tools when successful', () async {
      // act
      var result = await sut();
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, 2);
    });
    test('should return 0 when no tools found', () async {
      // arrange
      fakeToolRepository.tools.clear();
      // act
      var result = await sut();
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, 0);
    });
  });
}
