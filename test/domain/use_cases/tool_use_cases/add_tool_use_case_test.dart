import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/add_tool_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late AddToolUseCase sut;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    sut = AddToolUseCase(fakeToolRepository);
  });

  group('AddToolUseCase', () {
    test('should add a tool when successful', () async {
      // act
      var result = await sut('name', '2022', 'user');
      // assert
      expect(result, isA<ValueResult>());
      expect(result, isA<Result<void>>());
    });
    test('should return an error when tool with given name already exists', () async {
      // act
      var result = await sut('name1', '2022', 'holder');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError!.error, isNotEmpty);
    });
    test('should return an error when exception occured', () async {
      // act
      var result = await sut('exception', '2022', 'holder');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError!.error, isNotEmpty);
    });
  });
}
