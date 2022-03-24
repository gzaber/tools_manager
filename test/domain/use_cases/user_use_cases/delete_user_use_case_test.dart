import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/delete_user_use_case.dart.dart';
import 'package:async/async.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late DeleteUserUseCase sut;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
    sut = DeleteUserUseCase(fakeUserRepository);
  });

  group('DeleteUserUseCase', () {
    test('should delete a user when successful', () async {
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
      expect(result.asError, isNotNull);
    });
  });
}
