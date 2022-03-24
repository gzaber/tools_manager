import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/datasources/i_user_datasource.dart';
import 'package:tools_manager/data/models/user_model.dart';
import 'package:tools_manager/data/repositories/user_repository.dart';
import 'package:tools_manager/domain/entities/user.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([IUserDataSource])
void main() {
  late UserRepository sut;
  late MockIUserDataSource mockUserDataSource;

  setUp(() {
    mockUserDataSource = MockIUserDataSource();
    sut = UserRepository(mockUserDataSource);
  });

  //================================================================================================
  group('UserRepository.add', () {
    User user = User(name: 'username', mobileNumber: '666777888', role: 'admin');
    test('should add a user when successful', () async {
      // act
      await sut.add(user);
      // assert
      verify(mockUserDataSource.addUser(any)).called(1);
    });
  });
  //================================================================================================
  group('UserRepository.update', () {
    User user = User(id: 'id', name: 'username', mobileNumber: '666777888', role: 'admin');
    test('should update a user when successful', () async {
      // act
      await sut.update(user);
      // assert
      verify(mockUserDataSource.updateUser(any)).called(1);
    });
  });
  //================================================================================================
  group('UserRepository.delete', () {
    test('should delete a user when successful', () async {
      // act
      await sut.delete('id');
      // assert
      verify(mockUserDataSource.deleteUser(any)).called(1);
    });
  });
  //================================================================================================

  group('UserRepository.getById', () {
    UserModel userModel =
        UserModel(id: 'id', name: 'username', mobileNumber: '666777888', role: 'admin');
    test('should return a user when successful', () async {
      // arrange
      when(mockUserDataSource.getUserById(any)).thenAnswer((_) async => userModel);
      // act
      var result = await sut.getById('id');
      // assert
      expect(result, isNotNull);
      expect(result, userModel);
      verify(mockUserDataSource.getUserById(any)).called(1);
    });
    test('should return null when user not found', () async {
      // arrange
      when(mockUserDataSource.getUserById(any)).thenAnswer((_) async => null);
      // act
      var result = await sut.getById('wrongId');
      // assert
      expect(result, isNull);
      verify(mockUserDataSource.getUserById(any)).called(1);
    });
  });
  //================================================================================================
  group('UserRepository.getByMobileNumber', () {
    UserModel userModel =
        UserModel(id: 'id', name: 'username', mobileNumber: '666777888', role: 'admin');
    test('should return a user when successful', () async {
      // arrange
      when(mockUserDataSource.getUserByMobileNumber(any)).thenAnswer((_) async => userModel);
      // act
      var result = await sut.getByMobileNumber('666777888');
      // assert
      expect(result, isNotNull);
      expect(result, userModel);
      verify(mockUserDataSource.getUserByMobileNumber(any)).called(1);
    });
    test('should return null when user not found', () async {
      // arrange
      when(mockUserDataSource.getUserByMobileNumber(any)).thenAnswer((_) async => null);
      // act
      var result = await sut.getByMobileNumber('wrongMobileNr');
      // assert
      expect(result, isNull);
      verify(mockUserDataSource.getUserByMobileNumber(any)).called(1);
    });
  });
  //================================================================================================
  group('UserRepository.getByName', () {
    UserModel userModel =
        UserModel(id: 'id', name: 'username', mobileNumber: '666777888', role: 'admin');
    test('should return a user when successful', () async {
      // arrange
      when(mockUserDataSource.getUserByName(any)).thenAnswer((_) async => userModel);
      // act
      var result = await sut.getByName('username');
      // assert
      expect(result, isNotNull);
      expect(result, userModel);
      verify(mockUserDataSource.getUserByName(any)).called(1);
    });
    test('should return null when user not found', () async {
      // arrange
      when(mockUserDataSource.getUserByName(any)).thenAnswer((_) async => null);
      // act
      var result = await sut.getByName('wrongUsername');
      // assert
      expect(result, isNull);
      verify(mockUserDataSource.getUserByName(any)).called(1);
    });
  });
  //================================================================================================
  group('UserRepository.getAll', () {
    UserModel userModel =
        UserModel(id: 'id', name: 'username', mobileNumber: '666777888', role: 'admin');
    test('should return list of users when successful', () async {
      // arrange
      when(mockUserDataSource.getAllUsers()).thenAnswer((_) async => [userModel]);
      // act
      var result = await sut.getAll();
      // assert
      expect(result, isNotEmpty);
      expect(result, [userModel]);
      verify(mockUserDataSource.getAllUsers()).called(1);
    });

    test('should return empty list when no users found', () async {
      // arrange
      when(mockUserDataSource.getAllUsers()).thenAnswer((_) async => []);
      // act
      var result = await sut.getAll();
      // assert
      expect(result, isEmpty);
      verify(mockUserDataSource.getAllUsers()).called(1);
    });
  });

  //================================================================================================
  group('UserRepository.getByRole', () {
    UserModel userModel =
        UserModel(id: 'id', name: 'username', mobileNumber: '666777888', role: 'admin');
    test('should return list of users when successful', () async {
      // arrange
      when(mockUserDataSource.getUsersByRole(any)).thenAnswer((_) async => [userModel]);
      // act
      var result = await sut.getByRole('admin');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 1);
      verify(mockUserDataSource.getUsersByRole(any)).called(1);
    });

    test('should return empty list when no users found', () async {
      // arrange
      when(mockUserDataSource.getUsersByRole(any)).thenAnswer((_) async => []);
      // act
      var result = await sut.getByRole('unknownRole');
      // assert
      expect(result, isEmpty);
      verify(mockUserDataSource.getUsersByRole(any)).called(1);
    });
  });
  //================================================================================================
  group('UserRepository.countAll', () {
    test('should return number of users when successful', () async {
      // arrange
      when(mockUserDataSource.countAllUsers()).thenAnswer((_) async => 1);
      // act
      var result = await sut.countAll();
      // assert
      expect(result, isNotNull);
      expect(result, 1);
      verify(mockUserDataSource.countAllUsers()).called(1);
    });

    test('should return 0 when no users found', () async {
      // arrange
      when(mockUserDataSource.countAllUsers()).thenAnswer((_) async => 0);
      // act
      var result = await sut.countAll();
      // assert
      expect(result, isNotNull);
      expect(result, 0);
      verify(mockUserDataSource.countAllUsers()).called(1);
    });
  });
  //================================================================================================
  group('UserRepository.countByRole', () {
    test('should return number of users when successful', () async {
      // arrange
      when(mockUserDataSource.countUsersByRole(any)).thenAnswer((_) async => 1);
      // act
      var result = await sut.countByRole('role');
      // assert
      expect(result, isNotNull);
      expect(result, 1);
      verify(mockUserDataSource.countUsersByRole(any)).called(1);
    });

    test('should return 0 when no users found', () async {
      // arrange
      when(mockUserDataSource.countUsersByRole(any)).thenAnswer((_) async => 0);
      // act
      var result = await sut.countByRole('unknownRole');
      // assert
      expect(result, isNotNull);
      expect(result, 0);
      verify(mockUserDataSource.countUsersByRole(any)).called(1);
    });
  });
  //================================================================================================
}
