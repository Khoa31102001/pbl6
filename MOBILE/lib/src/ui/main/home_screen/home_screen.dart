import 'package:base_code/src/blocs/home_screen_bloc.dart';
import 'package:base_code/src/commons/widgets/rounded_image.dart';
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/main.dart';
import 'package:base_code/src/utils/app_boxshadow.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product/product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenBloC _bloC = HomeScreenBloC();
  MainState mainState = MainState();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Provider<HomeScreenBloC>(
        create: (_) => HomeScreenBloC(),
        dispose: (_, bloc) => bloc.dispose(),
        builder: (context, _) {
          return Container(
            decoration: const BoxDecoration(color: AppColors.pinkLight),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 70 / 668 * height,
                    ),
                    _poster(),
                    _listImageView(),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(isCheckHomeToProduct: true,),));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppImages.share,
                                width: 24,
                              ),
                              const SizedBox(
                                width: 11,
                              ),
                              const Text(AppStrings.seeMore)
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _poster() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 120),
          width: 343,
          height: 323,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: boxShadows),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              AppStrings.fashionUp,
              style: AppTextStyle.bannerHeadlineStyle,
            ),
            Text(
              AppStrings.makeYourStyle,
              style: Theme.of(context).textTheme.bodyText2,
            )
          ]),
        ),
        Positioned.fill(
            top: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                AppImages.bannerHome,
                width: 255,
              ),
            ))
      ],
    );
  }

  Widget _listImageView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Row(
        children: [
          Flexible(
              child: Column(
            children: const [
              Text(
                AppStrings.newArrival,
                style: AppTextStyle.bannerHeadlineStyle,
              ),
              RoundedImage(url: AppImages.home1),
              SizedBox(
                height: 10,
              ),
              RoundedImage(url: AppImages.home2),
            ],
          )),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(children: const [
              RoundedImage(url: AppImages.home3),
              SizedBox(
                height: 10,
              ),
              RoundedImage(url: AppImages.home4),
              SizedBox(
                height: 10,
              ),
              RoundedImage(url: AppImages.home5),
            ]),
          ),
        ],
      ),
    );
  }
}
