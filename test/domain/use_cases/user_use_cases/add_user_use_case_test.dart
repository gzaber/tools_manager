import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/add_user_use_case.dart';
import 'package:async/async.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late AddUserUseCase sut;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
    sut = AddUserUseCase(fakeUserRepository);
  });

  group('AddUserUseCase', () {
    test('should add a user when successful', () async {
      // act
      var result = await sut('username', '555666777', 'role');
      // assert
      expect(result, isA<ValueResult>());
      expect(result, isA<Result<void>>());
    });
    test('should return an error when user with given phone number already exists', () async {
      // act
      var result = await sut('username', '111111111', 'role');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
    test('should return an error when exception occured', () async {
      // act
      var result = await sut('username', 'wrongMobileNr', 'role');
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
