import 'package:test/test.dart';
import 'package:tools_manager/data/models/user_model.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/update_user_use_case.dart';
import 'package:async/async.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late UpdateUserUseCase sut;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
    sut = UpdateUserUseCase(fakeUserRepository);
  });

  group('UpdateUserUseCase', () {
    test('should update a user when successful', () async {
      UserModel userModel = UserModel(
        id: '11',
        name: 'name',
        mobileNumber: '111111111',
        role: 'role',
      );
      // act
      var result = await sut(userModel);
      // assert
      expect(result, isA<ValueResult>());
      expect(result, isA<Result<void>>());
    });
    test('should return an error when user with given phone number already exists', () async {
      UserModel userModel = UserModel(
        id: '11',
        name: 'name',
        mobileNumber: '222222222',
        role: 'role',
      );
      // act
      var result = await sut(userModel);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
    test('should return an error when exception occured', () async {
      UserModel userModel = UserModel(
        id: '11',
        name: 'user1',
        mobileNumber: 'wrongMobileNr',
        role: 'role1',
      );
      // act
      var result = await sut(userModel);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
