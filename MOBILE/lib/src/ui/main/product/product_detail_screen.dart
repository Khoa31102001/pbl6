import 'package:base_code/src/blocs/product_detail_bloc.dart';
import 'package:base_code/src/commons/widgets/loading_widget.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/models/product/product_size/product_size.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/common/app_bar.dart';
import 'package:base_code/src/ui/main/home_screen/widgets/slider_widget.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:base_code/src/ui/main/product/widget/category_button.dart';
import 'package:base_code/src/ui/main/product/widget/icon_text_button.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/app_textstyle.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/global_api.dart';
import '../../../commons/screens/error_screen.dart';
import '../../../manager/user_manager.dart';
import '../../../models/cart.dart';
import '../../../utils/toast_utils.dart';
import 'package:base_code/src/utils/integer_extension.dart';

import '../../auth/login_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.product, Key? key})
      : super(key: key);
  final Product product;
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductDetailBloC bloC;
  final CarouselController _carouselController = CarouselController();
  bool isCheckSelect = false;
  int? indexSelect;
  int numberQuantity = 0;
  String nameSize = "";
  int? quantity;
  late SharedPreferences pref;
  int? productSizeId;
  Cart cart = Cart();
  int priceDiscount = 0;
  bool logged = false;
  Product product = new Product();
  @override
  void initState() {
    product = widget.product;
     if (product.discount!.length > 0) {
                            priceDiscount =
                                ((product.discount![0].percent! / 100) *
                                        product.price!)
                                    .toInt();

                          }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<UserManager>().userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.error!.toString());
          }

          logged = snapshot.data != null;
          {
            return Provider<ProductDetailBloC>(
                create: ((context) => ProductDetailBloC()),
                builder: (context, child) {
                  bloC = context.read<ProductDetailBloC>();
                  return Scaffold(
                    appBar: customAppbar,
                    body: Container(
                      color: AppColors.pinkLight,
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          _slider(product),
                          _productDetail(product),
                          _description(product),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      )),
                    ),
                  );
                });
          }
        });
  }

  Widget _slider(Product product) {
    return Stack(
      children: [
        SliderWidget(
          listImage: product.images,
          controller: _carouselController,
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.pinkDark,
                  child: IconButton(
                      iconSize: 12,
                      splashRadius: 14,
                      color: Colors.white,
                      onPressed: () {
                        _carouselController.previousPage();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 12,
                      )),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.pinkDark,
                  child: IconButton(
                      iconSize: 12,
                      splashRadius: 14,
                      onPressed: () {
                        _carouselController.nextPage();
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 12,
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _productDetail(Product product) {
    print(
        "NAME SIZE == $nameSize \t $quantity \t $numberQuantity \t $productSizeId");
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          (product.category?.name ?? '--').toUpperCase(),
          style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                (product.name ?? '--'),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: AppTextStyle.headlineStyle,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            children: [
              Flexible(child: _rateDrawer()),
              const SizedBox(
                width: 20,
              ),
              const Text('2.9 ${AppStrings.review}'),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 15,
                width: 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primay),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(indexSelect == null
                  ? "0 ${AppStrings.quantity}"
                  : "${product.productSizes?[indexSelect!].quantity} ${AppStrings.quantity}"),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              '${product.price?.formatMoney}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ],
        ),
        Container(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: product.productSizes!.length,
            itemBuilder: (context, index) {
              ProductSize productSize = product.productSizes![index];
              if (index == 0) {
                return Row(
                  children: [
                    const Text('${AppStrings.size}:'),
                    const SizedBox(
                      width: 8,
                    ),
                    CategoryButton(
                      onPressed: () {
                        setState(() {
                          isCheckSelect = true;
                          indexSelect = index;
                          nameSize = productSize.size!.name!;
                          quantity = productSize.quantity;
                          productSizeId = productSize.id;
                        });
                      },
                      text: productSize.size?.name ?? "--",
                      buttonStatus: productSize.quantity == 0
                          ? ButtonStatus.disabled
                          : isCheckSelect && indexSelect == index
                              ? ButtonStatus.selected
                              : ButtonStatus.normal,
                    ),
                    const SizedBox(
                      width: 8,
                    )
                  ],
                );
              }
              return Row(
                children: [
                  CategoryButton(
                    onPressed: () {
                      setState(() {
                        isCheckSelect = true;
                        indexSelect = index;
                        nameSize = productSize.size!.name!;
                        quantity = productSize.quantity;
                        productSizeId = productSize.id;
                      });
                    },
                    text: productSize.size?.name ?? "--",
                    buttonStatus: productSize.quantity == 0
                        ? ButtonStatus.disabled
                        : isCheckSelect && indexSelect == index
                            ? ButtonStatus.selected
                            : ButtonStatus.normal,
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: product.productSizes!.isNotEmpty,
          child: Row(
            children: [
              const Text('${AppStrings.quantity}:'),
              SizedBox(
                width: 8,
              ),
              _quantityButton(product),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            const Text('${AppStrings.total}:'),
            const SizedBox(
              width: 5,
            ),
            FittedBox(
              child: Text(
                numberQuantity > 0
                    ? ((product.price! * numberQuantity) - priceDiscount)
                        .formatMoney
                    : "0d",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            FittedBox(
              child: Text(
                ((product.price! * numberQuantity) - 0).formatMoney,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconTextButton(
              onTap: () {
                if (quantity == 0) {
                  ToastUtils.showToast(AppStrings.outOfStock);
                } else if (nameSize == "") {
                  ToastUtils.showToast(AppStrings.chooseYourShoe);
                } else if (numberQuantity == 0) {
                  ToastUtils.showToast(AppStrings.chooseQuantity);
                } else {
                  bloC.addToCart(
                      product,
                      quantity!,
                      numberQuantity,
                      nameSize,
                      productSizeId!,
                      ((product.price! * numberQuantity) - priceDiscount));
                }
              },
              imageUrl: AppImages.cart,
              title: AppStrings.addToCart,
            ),
            const SizedBox(
              width: 10,
            ),
            IconTextButton(
              onTap: !logged
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    }
                  : () {
                      if (quantity == 0) {
                        ToastUtils.showToast(AppStrings.outOfStock);
                      } else if (nameSize == "") {
                        ToastUtils.showToast(AppStrings.chooseYourShoe);
                      } else if (numberQuantity == 0) {
                        ToastUtils.showToast(AppStrings.chooseQuantity);
                      } else {
                        cart
                          ..idProduct = product.id
                          ..quantity = quantity
                          ..numberQuantityBuy = numberQuantity
                          ..size = nameSize
                          ..productSizeId = productSizeId
                          ..priceAfterDiscount =
                              ((product.price! * numberQuantity) -
                                  priceDiscount)
                          ..percent = product.discount!.length > 0
                              ? product.discount![0].percent
                              : 0
                          ..product = product;
                        print(
                            "CARTPERCENT == ${cart.percent} \t ${product.discount!.length}");
                        globalApi.listCartSelect.add(cart);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderScreen(),
                            )).then((value) => globalApi.listCartSelect = []);
                      }
                    },
              imageUrl: AppImages.wallet,
              title: AppStrings.buyNow,
            ),
          ],
        )
      ]),
    );
  }

  Widget _rateDrawer({int rate = 3}) {
    return Row(
      children: [
        ...List.generate(
            rate,
            (index) => Image.asset(
                  AppImages.starFill,
                  height: 12,
                )).toList(),
        ...List.generate(
            5 - rate,
            (index) => Image.asset(
                  AppImages.starOutline,
                  height: 12,
                )).toList(),
      ],
    );
  }

  Widget _description(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(product.description ?? '--'),
    );
  }

  Widget _quantityButton(Product product) {
    print("INDEX == $indexSelect");
    const Color buttonColor = AppColors.primay;
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (numberQuantity < 2) {
                setState(() {
                  numberQuantity == 1;
                });
              } else {
                setState(() {
                  numberQuantity--;
                });
              }
            },
            icon: const Text('-'),
            iconSize: 10,
            splashRadius: 12,
          ),
          Text('$numberQuantity'),
          IconButton(
            onPressed: () {
              if (numberQuantity >
                      product.productSizes![indexSelect!].quantity! &&
                  indexSelect != -1) {
                setState(() {
                  numberQuantity ==
                      product.productSizes![indexSelect!].quantity;
                });
              } else {
                setState(() {
                  numberQuantity++;
                });
              }
            },
            icon: const Text('+'),
            iconSize: 10,
            splashRadius: 12,
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border.all(color: buttonColor),
          borderRadius: BorderRadius.circular(50)),
      // style: OutlinedButton.styleFrom(
      //     side: const BorderSide(color: buttonColor),
      //     shape: const StadiumBorder(),
      //     primary: buttonColor),
    );
  }
}
