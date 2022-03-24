import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/get_tool_by_name_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late GetToolByNameUseCase sut;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    sut = GetToolByNameUseCase(fakeToolRepository);
  });

  group('GetToolByNameUseCase', () {
    test('should return a tool when successful', () async {
      String name = 'name1';
      // act
      var result = await sut(name);
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value.name, name);
    });
    test('should return an error when tool not found', () async {
      String name = 'notfound';
      // act
      var result = await sut(name);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
    test('should return an error when exception occured', () async {
      String name = 'exception';
      // act
      var result = await sut(name);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
