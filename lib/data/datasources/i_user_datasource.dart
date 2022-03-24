import '../models/user_model.dart';

abstract class IUserDataSource {
  Future<void> addUser(UserModel userModel);
  Future<void> updateUser(UserModel userModel);
  Future<void> deleteUser(String id);
  Future<UserModel?> getUserById(String id);
  Future<UserModel?> getUserByMobileNumber(String mobileNumber);
  Future<UserModel?> getUserByName(String username);
  Future<List<UserModel>> getAllUsers();
  Future<List<UserModel>> getUsersByRole(String role);
  Future<int> countAllUsers();
  Future<int> countUsersByRole(String role);
}
