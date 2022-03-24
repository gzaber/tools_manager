import '../../domain/entities/user.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../datasources/i_user_datasource.dart';
import '../models/user_model.dart';

class UserRepository implements IUserRepository {
  final IUserDataSource _userDataSource;

  UserRepository(this._userDataSource);
  //================================================================================================
  @override
  Future<void> add(User user) async {
    UserModel userModel = UserModel(
      mobileNumber: user.mobileNumber,
      name: user.name,
      role: user.role,
    );
    return await _userDataSource.addUser(userModel);
  }

  //================================================================================================
  @override
  Future<void> update(User user) async {
    UserModel userModel = UserModel(
      id: user.id,
      name: user.name,
      mobileNumber: user.mobileNumber,
      role: user.role,
    );
    return await _userDataSource.updateUser(userModel);
  }

  //================================================================================================
  @override
  Future<void> delete(String id) async {
    return await _userDataSource.deleteUser(id);
  }

  //================================================================================================

  @override
  Future<User?> getById(String id) async {
    return await _userDataSource.getUserById(id);
  }

  //================================================================================================
  @override
  Future<User?> getByMobileNumber(String mobileNumber) async {
    return await _userDataSource.getUserByMobileNumber(mobileNumber);
  }

  //================================================================================================
  @override
  Future<User?> getByName(String username) async {
    return await _userDataSource.getUserByName(username);
  }

  //================================================================================================
  @override
  Future<List<User>> getAll() async {
    return await _userDataSource.getAllUsers();
  }

  //================================================================================================
  @override
  Future<List<User>> getByRole(String role) async {
    return await _userDataSource.getUsersByRole(role);
  }

  //================================================================================================
  @override
  Future<int> countAll() async {
    return await _userDataSource.countAllUsers();
  }

  //================================================================================================
  @override
  Future<int> countByRole(String role) async {
    return await _userDataSource.countUsersByRole(role);
  }

  //================================================================================================

}
