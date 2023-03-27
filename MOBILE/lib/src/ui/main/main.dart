import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/cart/cart_screen.dart';
import 'package:base_code/src/ui/main/common/app_bar.dart';
import 'package:base_code/src/ui/main/home_screen/home_screen.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:base_code/src/ui/main/order_momo/order_momo_screen.dart';
import 'package:base_code/src/ui/main/product/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:provider/provider.dart';

import '../../blocs/home_screen_bloc.dart';
import '../../utils/app_image.dart';
import '../auth/login_screen.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => MainState();
}

class MainState extends State<Main> {
  int selectedIndex = 0;
  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  bool logged = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    ProductScreen(),
    const CartScreen(),
    const OrderMomoScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      appBar: customAppbar,
      body: _screens[selectedIndex],
    );
  }

  Widget _drawer() {
    print("SELECT INDEX $selectedIndex");

    return StreamBuilder(
        stream: context.read<UserManager>().userStream,
        builder: (context, snapshot) {
          logged = snapshot.data != null;
          {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerHeader(context),
                  _listTitle(AppImages.home, AppStrings.home, () {
                    changeIndex(0);
                    Navigator.pop(context);
                  }, context, 0),
                  _listTitle(AppImages.product, AppStrings.product, () {
                    changeIndex(1);
                    Navigator.pop(context);
                  }, context, 1),
                  _listTitle(AppImages.cart_header, AppStrings.cart, () {
                    changeIndex(2);
                    Navigator.pop(context);
                  }, context, 2),
                  _listTitle(
                      AppImages.order,
                      AppStrings.order,
                      !logged
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ));
                            }
                          : () {
                              changeIndex(3);
                              Navigator.pop(context);
                            },
                      context,
                      3),
                  _listTitle(AppImages.logout, AppStrings.logout, () {
                    context.read<UserManager>().clearUser();
                    Navigator.pop(context);
                  }, context, -1)
                ],
              ),
            );
          }
        });
  }

  Widget _listTitle(String image, String title, Function() onTap,
      BuildContext context, int? index) {
    return ListTile(
      leading: Image.asset(image,
          width: 30,
          height: 30,
          color: index == selectedIndex ? AppColors.pinkDark : Colors.black),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            color: index == selectedIndex ? AppColors.pinkDark : Colors.black),
      ),
      onTap: onTap,
    );
  }
}

Widget _drawerHeader(BuildContext context) {
  return DrawerHeader(
    decoration: BoxDecoration(color: AppColors.pink),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 70, height: 70, child: Image.asset(AppImages.logo)),
              const Text(
                AppStrings.appName,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Menu',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ],
      ),
    ),
    margin: const EdgeInsets.all(0),
    padding: const EdgeInsets.all(0),
  );
}
