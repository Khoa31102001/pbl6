import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/struct/api_services/base_api.dart';
import 'package:base_code/src/struct/api_services/user_url.dart';

class UserRepository {
  final BaseApi _baseApi = BaseApi();
  Future<User?> getUserInfor() async {
    var respond = await _baseApi.getMethod(UserUrl.userInfor);
    if (respond['success']) {
      return User.fromJson(respond['data']);
    } else {
      return null;
    }
  }
}
