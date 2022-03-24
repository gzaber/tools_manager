import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/count_users_by_role_use_case.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late CountUsersByRoleUseCase sut;
  late FakeUserRepository fakeUserRepository;
  setUp(() {
    fakeUserRepository = FakeUserRepository();
    sut = CountUsersByRoleUseCase(fakeUserRepository);
  });

  group('CountUsersByRoleUseCase', () {
    test('should return number of users when successful', () async {
      // act
      var result = await sut('user');
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, 3);
    });
    test('should return 0 when no users found', () async {
      // arrange
      fakeUserRepository.users.clear();
      // act
      var result = await sut('unknownRole');
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, 0);
    });
  });
}
