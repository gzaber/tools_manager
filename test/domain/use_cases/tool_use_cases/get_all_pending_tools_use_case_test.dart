import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/get_all_pending_tools_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late GetAllPendingToolsUseCase sut;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    sut = GetAllPendingToolsUseCase(fakeToolRepository);
  });

  group('GetAllPendingToolsUseCase', () {
    test('should return list of tools when successful', () async {
      // act
      var result = await sut();
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, isNotEmpty);
      expect(result.asValue!.value.length, 2);
    });
    test('should return an error when no tools found', () async {
      // arrange
      fakeToolRepository.tools.clear();
      // act
      var result = await sut();
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
