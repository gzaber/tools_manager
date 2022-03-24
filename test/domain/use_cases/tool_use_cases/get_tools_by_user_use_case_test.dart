import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/get_tools_by_user_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';
import 'package:async/async.dart';

void main() {
  late GetToolsByUserUseCase sut;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    sut = GetToolsByUserUseCase(fakeToolRepository);
  });

  group('GetToolsByUserUseCase', () {
    test('should return list of tools when successful', () async {
      // act
      var result = await sut('user1');
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value.length, 3);
    });
    test('should return an error when no tools found', () async {
      // act
      var result = await sut('unknownHolder');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
    test('should return an error when exception occured', () async {
      // act
      var result = await sut('exception');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
