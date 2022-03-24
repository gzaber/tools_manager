import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/get_tool_by_id_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late GetToolByIdUseCase sut;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    sut = GetToolByIdUseCase(fakeToolRepository);
  });

  group('GetToolByIdUseCase', () {
    test('should return a tool when successful', () async {
      String id = '11';
      // act
      var result = await sut(id);
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value.id, id);
    });
    test('should return an error when tool not found', () async {
      String id = '00';
      // act
      var result = await sut(id);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
    test('should return an error when exception occured', () async {
      String id = 'wrongid';
      // act
      var result = await sut(id);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
