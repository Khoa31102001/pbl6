import 'dart:convert';

import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/struct/api_services/get_user_infor_mixin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager with UserMixin {
  static String _globalToken = '';
  final BehaviorSubject<User?> _currentUser = BehaviorSubject<User?>();
  ValueStream<User?> get userStream => _currentUser.stream;
  static String get globalToken => _globalToken;
  User? get currentUser => _currentUser.value;
  Future<void> updateUser(User? user) async {
    _currentUser.add(user);
  }

  Future<void> clearUser() async {
    _globalToken = '';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    _currentUser.add(null);
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('access-token');
  }

  static void updateGlobalToken(String token) {
    _globalToken = token;
  }

  Future<bool> storeAccessToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _globalToken = token;
    return pref.setString('access-token', token);
  }

  Future<String?> getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('user-name');
  }

  Future<bool> storeUsername(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString('user-name', name);
  }

  Future<bool> storeUser(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString('user', json.encode(user.toBaseJson()));
  }

  Future<User?> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userJson = pref.getString('user');
    if (userJson == null) return null;
    return User.fromJson(json.decode(userJson));
  }

  void dispose() {
    _currentUser.close();
  }
}
