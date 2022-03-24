import 'package:tools_manager/domain/entities/user.dart';
import 'package:tools_manager/domain/repositories/i_user_repository.dart';

class FakeUserRepository implements IUserRepository {
  List<User> users = [
    User(id: '11', name: 'user1', mobileNumber: '111111111', role: 'admin'),
    User(id: '22', name: 'user2', mobileNumber: '222222222', role: 'user'),
    User(id: '33', name: 'user3', mobileNumber: '333333333', role: 'user'),
    User(id: '44', name: 'user4', mobileNumber: '444444444', role: 'user'),
  ];

  //================================================================================================
  @override
  Future<void> add(User user) async {
    int.parse(user.mobileNumber);

    return users.add(user);
  }

  //================================================================================================
  @override
  Future<void> update(User user) async {
    int.parse(user.mobileNumber);
  }

  //================================================================================================
  @override
  Future<void> delete(String id) async {
    int.parse(id);
  }

  //================================================================================================
  @override
  Future<List<User>> getAll() async {
    if (users.isEmpty) {
      return [];
    } else {
      return users;
    }
  }

  //================================================================================================
  @override
  Future<User?> getById(String id) async {
    int.parse(id);

    var result = users.where((user) => user.id == id).toList();

    if (result.isEmpty) {
      return null;
    } else {
      return result.first;
    }
  }

  //================================================================================================
  @override
  Future<User?> getByMobileNumber(String mobileNumber) async {
    int.parse(mobileNumber);

    var result = users.where((user) => user.mobileNumber == mobileNumber).toList();

    if (result.isEmpty) {
      return null;
    } else {
      return result.first;
    }
  }

  //================================================================================================
  @override
  Future<User?> getByName(String username) async {
    if (username == 'exception') throw Exception('exception');

    var result = users.where((user) => user.name == username).toList();

    if (result.isEmpty) {
      return null;
    } else {
      return result.first;
    }
  }

  //================================================================================================
  @override
  Future<int> countAll() async {
    return users.length;
  }

  //================================================================================================
  @override
  Future<int> countByRole(String role) async {
    if (role == 'exception') throw Exception('exception');

    var result = users.where((user) => user.role == role).toList();

    if (result.isEmpty) {
      return 0;
    } else {
      return result.length;
    }
  }

  //================================================================================================
  @override
  Future<List<User>> getByRole(String role) async {
    if (role == 'exception') throw Exception('exception');

    var result = users.where((user) => user.role == role).toList();

    if (result.isEmpty) {
      return [];
    } else {
      return result;
    }
  }
  //================================================================================================
}
