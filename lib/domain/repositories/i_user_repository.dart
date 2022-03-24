import '../entities/user.dart';

abstract class IUserRepository {
  Future<void> add(User user);
  Future<void> update(User user);
  Future<void> delete(String id);
  Future<User?> getById(String id);
  Future<User?> getByMobileNumber(String mobileNumber);
  Future<User?> getByName(String username);
  Future<List<User>> getAll();
  Future<List<User>> getByRole(String role);
  Future<int> countAll();
  Future<int> countByRole(String role);
}
