import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:test/test.dart';
import 'package:tools_manager/data/datasources/firestore/firestore_user_datasource.dart';
import 'package:tools_manager/data/models/user_model.dart';

void main() {
  late FirestoreUserDataSource sut;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late CollectionReference users;

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    users = fakeFirebaseFirestore.collection('users');
    sut = FirestoreUserDataSource(users);
  });

  //================================================================================================
  group('addUser', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should add a user when successful', () async {
      // act
      await sut.addUser(userModel);
      // assert
      expect(await users.get().then((snapshot) => snapshot.docs), isNotEmpty);
      expect(await users.get().then((snapshot) => snapshot.docs.length), 1);
    });
  });
  //================================================================================================
  group('updateUser', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should update a user when successful', () async {
      // arrange
      var ref = await users.add(userModel.toMap());
      // act
      await sut.updateUser(UserModel(
          id: ref.id,
          mobileNumber: userModel.mobileNumber,
          name: 'updatedName',
          role: userModel.role));
      // assert
      expect(await users.get().then((snapshot) => snapshot.docs), isNotEmpty);
      expect(await users.get().then((snapshot) => snapshot.docs.length), 1);
      expect(
          await users.get().then((snapshot) => UserModel.fromMap(
                  snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>)
              .name),
          'updatedName');
      expect(
          await users.get().then((snapshot) => UserModel.fromMap(
                  snapshot.docs.first.id, snapshot.docs.first.data() as Map<String, dynamic>)
              .role),
          userModel.role);
    });
  });
  //================================================================================================
  group('deleteUser', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should delete a user when successful', () async {
      // arrange
      var ref = await users.add(userModel.toMap());
      // act
      await sut.deleteUser(ref.id);
      // assert
      expect(await users.get().then((snapshot) => snapshot.docs), isEmpty);
      expect(await users.get().then((snapshot) => snapshot.docs.length), 0);
    });
  });
  //================================================================================================

  group('getUserById', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should return user when successful', () async {
      // arrange
      var ref = await users.add(userModel.toMap());
      // act
      var result = await sut.getUserById(ref.id);
      // assert
      expect(result, isNotNull);
      expect(result!.name, 'name');
    });
    test('should return null when user not found', () async {
      // act
      var result = await sut.getUserById('wrongId');
      // assert
      expect(result, isNull);
    });
  });
  //================================================================================================
  group('getUserByMobileNumber', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should return user when successful', () async {
      // arrange
      await users.add(userModel.toMap());
      // act
      var result = await sut.getUserByMobileNumber(userModel.mobileNumber);
      // assert
      expect(result, isNotNull);
      expect(result!.name, 'name');
    });
    test('should return null when user not found', () async {
      // act
      var result = await sut.getUserByMobileNumber('wrongMobileNumber');
      // assert
      expect(result, isNull);
    });
  });
  //================================================================================================
  group('getUserByName', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'username', role: 'role');
    test('should return user when successful', () async {
      // arrange
      await users.add(userModel.toMap());
      // act
      var result = await sut.getUserByName(userModel.name);
      // assert
      expect(result, isNotNull);
      expect(result!.name, 'username');
    });
    test('should return null when user not found', () async {
      // act
      var result = await sut.getUserByName('wrongUsername');
      // assert
      expect(result, isNull);
    });
  });
  //================================================================================================
  group('getAllUsers', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should return list of users when successful', () async {
      // arrange
      await users.add(userModel.toMap());
      // act
      var result = await sut.getAllUsers();
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 1);
    });
    test('should return empty list when no users found', () async {
      // act
      var result = await sut.getAllUsers();
      // assert
      expect(result, isEmpty);
    });
  });
  //================================================================================================
  group('getUsersByRole', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should return list of users when successful', () async {
      // arrange
      await users.add(userModel.toMap());
      // act
      var result = await sut.getUsersByRole('role');
      // assert
      expect(result, isNotEmpty);
      expect(result.length, 1);
    });
    test('should return empty list when no users found', () async {
      // arrange
      await users.add(userModel.toMap());
      // act
      var result = await sut.getUsersByRole('wrongRole');
      // assert
      expect(result, isEmpty);
    });
  });
  //================================================================================================
  group('countAllUsers', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should return number of users when successful', () async {
      // arrange
      await users.add(userModel.toMap());
      // act
      var result = await sut.countAllUsers();
      // assert
      expect(result, isNotNull);
      expect(result, 1);
    });
    test('should return 0 when no users found', () async {
      // act
      var result = await sut.countAllUsers();
      // assert
      expect(result, isNotNull);
      expect(result, 0);
    });
  });
  //================================================================================================
  group('countUsersByRole', () {
    UserModel userModel = UserModel(mobileNumber: '666777888', name: 'name', role: 'role');
    test('should return number of users when successful', () async {
      // arrange
      await users.add(userModel.toMap());
      // act
      var result = await sut.countUsersByRole('role');
      // assert
      expect(result, isNotNull);
      expect(result, 1);
    });
    test('should return 0 when no users found', () async {
      // act
      var result = await sut.countUsersByRole('wrongRole');
      // assert
      expect(result, isNotNull);
      expect(result, 0);
    });
  });
  //================================================================================================
}
