import 'package:async/async.dart';

import 'package:test/test.dart';
import 'package:tools_manager/domain/use_cases/common_use_cases/count_tools_in_tool_room_use_case.dart';

import '../../../fake_repositories/fake_tool_repository.dart';
import '../../../fake_repositories/fake_user_repository.dart';

void main() {
  late CountToolsInToolRoomUseCase sut;
  late FakeToolRepository fakeToolRepository;
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    fakeToolRepository = FakeToolRepository();
    fakeUserRepository = FakeUserRepository();
    sut = CountToolsInToolRoomUseCase(fakeToolRepository, fakeUserRepository);
  });

  group('CountToolsInToolRoomUseCase', () {
    test('should return number of tools when successful', () async {
      // act
      var result = await sut();
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, 1);
    });
    test('should return 0 when no tools found', () async {
      // arrange
      fakeToolRepository.tools.clear();
      // act
      var result = await sut();
      // assert
      expect(result, isA<ValueResult>());
      expect(result.asValue!.value, 0);
    });
  });
}
