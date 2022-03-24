import 'package:test/test.dart';
import 'package:async/async.dart';
import 'package:tools_manager/domain/use_cases/user_use_cases/get_user_by_mobile_number_use_case.dart';

import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late GetUserByMobileNumberUseCase sut;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeUserRepository = FakeUserRepository();
    sut = GetUserByMobileNumberUseCase(fakeUserRepository);
  });

  group('GetUserByMobileNumberUseCase', () {
    test('should return a user when successful', () async {
      String mobileNumber = '111111111';
      // act
      var result = await sut(mobileNumber);
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value.mobileNumber, mobileNumber);
    });
    test('should return an error when user not found', () async {
      String mobileNumber = '000000000';
      // act
      var result = await sut(mobileNumber);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
    test('should return an error when exception occured', () async {
      String mobileNumber = 'wrongMobileNr';
      // act
      var result = await sut(mobileNumber);
      // assert
      expect(result, isA<ErrorResult>());
      expect(result.asError, isNotNull);
    });
  });
}
