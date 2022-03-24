import 'package:test/test.dart';
import 'package:async/async.dart';
import 'package:tools_manager/domain/use_cases/common_use_cases/move_deleted_user_tools_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';
import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late MoveDeletedUserToolsUseCase sut;
  late FakeToolRepository fakeToolRepository;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    fakeUserRepository = FakeUserRepository();
    sut = MoveDeletedUserToolsUseCase(fakeToolRepository, fakeUserRepository);
  });

  group('UpdateToolsByUserUseCase', () {
    test('should move tools when successful', () async {
      // act
      var result = await sut('11', 'user2');
      // assert
      expect(result, isA<ValueResult>());
      expect(result, isA<Result<void>>());
    });

    test('should return an error when failure', () async {
      // act
      var result = await sut('wrongId', 'user2');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
