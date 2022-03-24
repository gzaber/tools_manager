import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/entities/tool.dart';
import 'package:tools_manager/domain/use_cases/tool_use_cases/update_tool_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';

void main() {
  late UpdateToolUseCase sut;
  late FakeToolRepository fakeToolRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    sut = UpdateToolUseCase(fakeToolRepository);
  });

  group('UpdateToolUseCase', () {
    test('should update a tool when successful', () async {
      Tool tool = Tool(
        id: '11',
        name: 'nameUpdated',
        date: '2022',
        giver: 'giver',
        holder: 'holderUpdated',
        receiver: 'receiverUpdated',
      );
      // act
      var result = await sut(tool);
      // assert
      expect(result, isA<ValueResult>());
      expect(result, isA<Result<void>>());
    });
    test('should return an error when tool with given name already exists',
        () async {
      Tool tool = Tool(
        id: '111',
        name: 'name1',
        date: '2022',
        giver: 'giver',
        holder: 'holderUpdated',
        receiver: 'receiverUpdated',
      );
      // act
      var result = await sut(tool);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
    test('should return an error when exception occured', () async {
      Tool tool = Tool(
        id: 'wrongId',
        name: 'nameUpdated',
        date: '2022',
        giver: 'giver',
        holder: 'holderUpdated',
        receiver: 'receiverUpdated',
      );
      // act
      var result = await sut(tool);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
