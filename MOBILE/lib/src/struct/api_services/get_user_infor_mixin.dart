import 'package:flutter/material.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/struct/api_services/base_api.dart';
import 'package:base_code/src/struct/api_services/user_url.dart';

// this Mixin will be used on both Spash screen and Login screen
mixin UserMixin {
  final BaseApi _baseRepository = BaseApi();

  Future<User?> getUserInfor() async {
    // get token from local storage
    String? token = await UserManager.getAccessToken();
    if (token != null) {
      UserManager.updateGlobalToken(token);
      try {
        var respond = await _baseRepository.getMethod(UserUrl.userInfor);
        return User.fromJson(respond);
      } catch (error, stackTrace) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
      }
    }
    return null;
  }
}
