import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/get_all_users_use_case.dart';
import 'package:async/async.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late GetAllUsersUseCase sut;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
    sut = GetAllUsersUseCase(fakeUserRepository);
  });

  group('GetAllUsersUseCase', () {
    test('should return list of users when successful', () async {
      // act
      var result = await sut();
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, isNotEmpty);
      expect(result.asValue!.value.length, 4);
    });
    test('should return an error when no users found', () async {
      // arrange
      fakeUserRepository.users.clear();
      // act
      var result = await sut();
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
