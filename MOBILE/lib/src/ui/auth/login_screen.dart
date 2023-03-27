import 'package:base_code/src/blocs/login_bloc.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/models/user.dart';
import 'package:base_code/src/repositories/auth_repo.dart';
import 'package:base_code/src/struct/api_services/get_user_infor_mixin.dart';
import 'package:base_code/src/ui/auth/sign_up_screen.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with UserMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  late final UserManager _userManager = context.read<UserManager>();

  Future storeUserandAddUser(String token) async {
    await _userManager.storeAccessToken(token);
    User? user = await getUserInfor();
    _userManager.updateUser(user);
  }

  Future login(String email, String pass) async {
    String token = await _authRepository.login(email: email, password: pass);
    storeUserandAddUser(token);
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final double paddingSize = 30 / 667 * MediaQuery.of(context).size.height;
    return Provider(
        create: (_) => LoginBloC(_userManager),
        builder: (context, _) {
          context
              .read<LoginBloC>()
              .checkAuthStatus()
              .onError((error, stackTrace) {
            showErrorDialog(context, error);
          });
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(AppImages.bannerLogin),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              AppStrings.welcomeBack,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.headlineStyle,
                            ),
                            SizedBox(
                              height: paddingSize,
                            ),
                            ElevatedButton(
                                onPressed: () async {},
                                child: const Text(AppStrings.signinWithGoogle)),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: paddingSize),
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
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              obscureText: !isVisible ? true : false,
                              decoration: InputDecoration(
                                  hintText: AppStrings.passwordHint,
                                  suffix: InkWell(
                                    onTap: () {
                                      isVisible = !isVisible;
                                      setState(() {
                                        
                                      });
                                    },
                                    child: isVisible ? Icon(Icons.visibility_off) :  Icon(Icons.visibility)
                                  )),
                              controller: passwordController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    AppStrings.forgotPassword,
                                    style: AppTextStyle.linkTextStyle,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: paddingSize,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  try {
                                    showLoading(context,
                                        message: AppStrings.logingIn);
                                    await login(emailController.text,
                                        passwordController.text);
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  } catch (error, stackStrace) {
                                    debugPrint(error.toString());
                                    debugPrintStack(stackTrace: stackStrace);
                                    Navigator.pop(context);
                                    showErrorDialog(context, error);
                                  }
                                },
                                child: const Text(AppStrings.login)),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SignUpScreen()));
                                  },
                                  child: const Text(
                                    AppStrings.signup,
                                    style: AppTextStyle.linkTextStyle,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
