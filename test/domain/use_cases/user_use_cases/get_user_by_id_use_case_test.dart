import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/get_user_by_id_use_case.dart';
import 'package:async/async.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late GetUserByIdUseCase sut;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
    sut = GetUserByIdUseCase(fakeUserRepository);
  });

  group('GetUserByIdUseCase', () {
    test('should return a user when successful', () async {
      String id = '11';
      // act
      var result = await sut(id);
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value.id, id);
    });
    test('should return an error when user not found', () async {
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
