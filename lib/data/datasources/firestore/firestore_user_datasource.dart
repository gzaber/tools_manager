import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';
import '../i_user_datasource.dart';

class FirestoreUserDataSource implements IUserDataSource {
  final CollectionReference _users;

  FirestoreUserDataSource(this._users);

  //================================================================================================
  @override
  Future<void> addUser(UserModel userModel) async {
    await _users.add(userModel.toMap());
  }

  //================================================================================================
  @override
  Future<void> updateUser(UserModel userModel) async {
    return await _users.doc(userModel.id).update(userModel.toMap());
  }

  //================================================================================================
  @override
  Future<void> deleteUser(String id) async {
    return await _users.doc(id).delete();
  }

  //================================================================================================
  @override
  Future<UserModel?> getUserById(String id) async {
    return await _users.doc(id).get().then((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(id, snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  //================================================================================================
  @override
  Future<UserModel?> getUserByMobileNumber(String mobileNumber) async {
    return await _users.where('mobileNumber', isEqualTo: mobileNumber).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      } else {
        return snapshot.docs
            .map((qds) => UserModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList()
            .first;
      }
    });
  }

  //================================================================================================
  @override
  Future<UserModel?> getUserByName(String username) async {
    return await _users.where('name', isEqualTo: username).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      } else {
        return snapshot.docs
            .map((qds) => UserModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList()
            .first;
      }
    });
  }

  //================================================================================================
  @override
  Future<List<UserModel>> getAllUsers() async {
    return await _users.get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((qds) => UserModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  //================================================================================================
  @override
  Future<List<UserModel>> getUsersByRole(String role) async {
    return await _users.where('role', isEqualTo: role).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((qds) => UserModel.fromMap(qds.id, qds.data() as Map<String, dynamic>))
            .toList();
      }
    });
  }

  //================================================================================================
  @override
  Future<int> countAllUsers() async {
    return await _users.get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 0;
      } else {
        return snapshot.docs.length;
      }
    });
  }

  //================================================================================================
  @override
  Future<int> countUsersByRole(String role) async {
    return await _users.where('role', isEqualTo: role).get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 0;
      } else {
        return snapshot.docs.length;
      }
    });
  }

  //================================================================================================

}
