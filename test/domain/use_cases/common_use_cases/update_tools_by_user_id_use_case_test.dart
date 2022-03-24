import 'package:test/test.dart';
import 'package:async/async.dart';
import 'package:tools_manager/domain/use_cases/common_use_cases/update_tools_by_user_id_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';
import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late UpdateToolsByUserIdUseCase sut;
  late FakeToolRepository fakeToolRepository;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    fakeUserRepository = FakeUserRepository();
    sut = UpdateToolsByUserIdUseCase(fakeToolRepository, fakeUserRepository);
  });

  group('UpdateToolsByUserUseCase', () {
    test('should update tools when successful', () async {
      // act
      var result = await sut('11', 'updatedUsername');
      // assert
      expect(result, isA<ValueResult>());
      expect(result, isA<Result<void>>());
    });

    test('should return an error when failure', () async {
      // act
      var result = await sut('123', 'updatedUsername');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
