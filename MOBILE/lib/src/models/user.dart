import 'package:base_code/src/extension/roles_ex.dart';
import 'package:base_code/src/utils/enums/roles.dart';

class User {
  User();
  String id = '';
  // List<Role> rolesId = [];
  Role roles = Role.consumer;
  String birthDay = '';
  String fullName = '';
  String email = '';
  bool status = true;
  String avatarUrl = '';
  String gender = '';
  factory User.fromJson(Map<String, dynamic> json) {
    User user = User()
      ..id = json['_id'] ?? ''
      ..roles = json['role'].toString().roleFromString() ?? Role.consumer
      ..fullName = json['fullName'] ?? ''
      ..email = json['email'] ?? ''
      ..avatarUrl = json['avatarUrl'] ?? '';
    return user;
  }

  Map<String, dynamic> toBaseJson() {
    throw Exception('This function is not ready');
  }

  bool isEnoughBaseInformation() {
    throw Exception('This function is not ready');
  }
}
