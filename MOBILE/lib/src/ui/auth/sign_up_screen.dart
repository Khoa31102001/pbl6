import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/repositories/auth_repo.dart';
import 'package:base_code/src/struct/api_services/get_user_infor_mixin.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with UserMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  late final UserManager _userManager = context.read<UserManager>();

  Future storeUserandAddUser(String token) async {
    await _userManager.storeAccessToken(token);
    User? user = await getUserInfor();
    _userManager.updateUser(user);
  }

  Future signup(String email) async {
    await _authRepository.signup(email: email);
  }

  @override
  Widget build(BuildContext context) {
    final double paddingSize = 30 / 667 * MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AppImages.bannerLogin),
            SizedBox(
              height: paddingSize,
            ),
            const Text(
              AppStrings.welcomeEshoping,
              textAlign: TextAlign.center,
              style: AppTextStyle.headlineStyle,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                          onPressed: () async {},
                          child: const Text(AppStrings.signinWithGoogle)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: paddingSize),
                        child: const Text(
                          AppStrings.or,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.secondaryText,
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: AppStrings.emailHint),
                        controller: emailController,
                      ),
                      
                      SizedBox(
                        height: paddingSize,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              showLoading(context,
                                  message: AppStrings.logingIn);
                              await signup(emailController.text);
                              Navigator.pop(context);
                              await showSuccessDialog(
                                  context, AppStrings.checkMail);
                              Navigator.pop(context);
                            } catch (error) {
                              debugPrint(error.toString());
                              Navigator.pop(context);
                              showErrorDialog(context, error);
                            }
                          },
                          child: const Text(AppStrings.signup)),
                      SizedBox(
                        height: paddingSize,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(AppStrings.donotHaveAccount),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              AppStrings.login,
                              style: AppTextStyle.linkTextStyle,
                            ),
                          )
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
