import 'package:base_code/src/struct/api_services/auth_url.dart';
import 'package:base_code/src/struct/api_services/base_api.dart';

class AuthRepository {
  final BaseApi _baseApi = BaseApi();
  Future<String> login(
      {required String email, required String password}) async {
    Map<String, String> body = {'email': email, 'password': password};
    var respond = await _baseApi.postMethod(AuthUrl.login, body: body);
    return respond['data']['accessToken'];
  }

  Future<void> signup({required String email}) async {
    Map<String, String> body = {'email': email};
    var respond = await _baseApi.postMethod(AuthUrl.signup, body: body);
    if (respond['success']) {
    } else {
      throw Exception(respond['message']);
    }
  }
}
