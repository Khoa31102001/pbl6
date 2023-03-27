import 'package:base_code/src/ui/auth/login_screen.dart';
import 'package:base_code/src/ui/main/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/commons/screens/error_screen.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/ui/main/main.dart';
import 'package:provider/provider.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<UserManager>().userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.error!.toString());
          }
          bool logged = snapshot.data != null;
          if (logged) {
            return const Main();
          } else {
            return const LoginScreen();
          }
        });
  }
}
