import 'dart:convert';

import 'package:base_code/src/api/global_api.dart';
import 'package:base_code/src/blocs/home_screen_bloc.dart';
import 'package:base_code/src/ui/main/main.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/app.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/struct/app_theme.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/models/cart.dart';

late SharedPreferences pref;

void main() async{
  runApp(
    (MultiProvider(
      providers: [
         Provider<UserManager>(
        create: (_) => UserManager(),
        dispose: (_, userManager) => userManager.dispose(),
      ),
      Provider<HomeScreenBloC>(
        create: (_) => HomeScreenBloC(),
        dispose: (_, homeScreenBloC) => homeScreenBloC.dispose(),
      ),
      ],
      child: MyApp()))
  );
   pref = await SharedPreferences.getInstance();
    String? jsonProducts = pref.getString('listCart');
    jsonProducts ??= '[]';
    List listMapProduct = (json.decode(jsonProducts));
    List<Cart> listCart =
        listMapProduct.map((json) => Cart.fromJson(json)).toList();
    globalApi.listCart = listCart;
   
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: appTheme,
      home: Main()
    );
  }
}
