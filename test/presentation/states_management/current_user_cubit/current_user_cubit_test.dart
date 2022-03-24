import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tools_manager/domain/entities/user.dart';
import 'package:tools_manager/presentation/states_management/current_user_cubit/current_user_cubit.dart';

void main() {
  late CurrentUserCubit sut;

  setUp(() {
    sut = CurrentUserCubit();
  });

  group('CurrentUserCubit', () {
    blocTest<CurrentUserCubit, User>(
      'emits [] when nothing is updated',
      build: () => sut,
      expect: () => [],
    );
    blocTest<CurrentUserCubit, User>(
      'emits [User] when updated',
      build: () => sut,
      act: (cubit) => cubit
          .update(User(mobileNumber: '666777888', name: 'name', role: 'role')),
      expect: () => [isA<User>()],
    );
  });
}
