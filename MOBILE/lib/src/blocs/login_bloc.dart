import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/repositories/user_repo.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:flutter/material.dart';

class LoginBloC extends BaseBloC {
  late final UserManager _userManager;
  late final UserRepository _userRepository = UserRepository();
  LoginBloC(this._userManager);
  Future<void> checkAuthStatus() async {
    try {
      String? token = await UserManager.getAccessToken();
      if (token != null) {
        await _userManager.storeAccessToken(token);
        User? user = await _userRepository.getUserInfor();
        if (user != null) {
          _userManager.updateUser(user);
        } else {
          throw AppStrings.tokenExpired;
        }
      }
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      await _userManager.clearUser();
      rethrow;
    }
  }

  @override
  void dispose() {}
}
