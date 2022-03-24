import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    String? id,
    required String role,
    required String mobileNumber,
    required String name,
  }) : super(
          id: id,
          name: name,
          mobileNumber: mobileNumber,
          role: role,
        );

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'],
      mobileNumber: map['mobileNumber'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'role': role,
    };
  }
}
