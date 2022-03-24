import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/delete_tool_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late DeleteToolUseCase sut;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    sut = DeleteToolUseCase(fakeToolRepository);
  });

  group('DeleteToolUseCase', () {
    test('should delete a tool when successful', () async {
      // act
      var result = await sut('11');
      // assert
      expect(result, isA<ValueResult>());
      expect(result, isA<Result<void>>());
    });
    test('should return an error when exception occured', () async {
      // act
      var result = await sut('wrongid');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError!.error, isNotEmpty);
    });
  });
}
