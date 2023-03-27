import 'package:base_code/src/api/global_api.dart';
import 'package:base_code/src/blocs/cart_bloc.dart';
import 'package:base_code/src/commons/widgets/loading_widget.dart';
import 'package:base_code/src/models/cart.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/cart/cart_product.dart';
import 'package:base_code/src/ui/main/momo_webview/momo_screen.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:base_code/src/ui/main/product/widget/icon_text_button.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:base_code/src/utils/integer_extension.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../manager/user_manager.dart';
import '../../../utils/toast_utils.dart';
import '../../auth/login_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloC bloC;
  late List<Cart> listCartSelect = [];
  List<int> listNumberQuantity = [];
  List<Cart> listCart = [];
  late SharedPreferences pref;
  List<Product> cartProducts = [];
  List<bool> listCheck = [];
  Cart cart = Cart();

  @override
  void initState() {
    listCart = globalApi.listCart;
    for (Cart i in listCart) {
      listNumberQuantity.add(i.numberQuantityBuy!);
      cartProducts.add(i.product!);
      listCheck.add(false);
    }
    super.initState();
  }

  @override
  void dispose() {
    globalApi.listCart.clear();
    removeListCart();
    super.dispose();
  }

  void removeListCart() async {
    pref = await SharedPreferences.getInstance();
    pref.remove('listCart');
  }

  bool logged = false;

  @override
  Widget build(BuildContext context) {
    String totalPrice = getTotalPrice();
    return StreamBuilder(
        stream: context.read<UserManager>().userStream,
        builder: (context, snapshot) {
          logged = snapshot.data != null;
          {
            return Container(
              color: AppColors.pinkLight,
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 100,
                    child: const Text(
                      AppStrings.cart,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  cartProducts.isEmpty
                      ? Image.asset(AppImages.cartEmpty)
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    AppStrings.product,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    AppStrings.quantity,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                  children: List.generate(
                                cartProducts.length,
                                (index) {
                                  return _cartDetail(
                                      index % 2 == 0,
                                      cartProducts[index],
                                      globalApi.listCart[index],
                                      index);
                                },
                              )),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(AppStrings.total + ':'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          totalPrice,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    IconTextButton(
                                        imageUrl: AppImages.wallet,
                                        title: AppStrings.checkout,
                                        onTap:!logged ? (){
                 Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
              } : () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderScreen(),
                                              ));
                                        })
                                  ]),
                            )
                          ],
                        )
                ]),
              ),
            );
          }
        });
  }

  Widget _cartDetail(bool isStroke, Product? product, Cart cart, int index) {
    print("CHECK ${listCheck[index]}");
    print("CHECK ADD1 ${globalApi.listCart[index].numberQuantityBuy}");

    return Container(
      color: isStroke ? Colors.black.withOpacity(0.05) : null,
      padding: EdgeInsets.all(12),
      child: Row(children: [
        !listCheck[index]
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    listCheck[index] = !listCheck[index];
                    if (globalApi.listCartSelect != []) {
                      if (listCheck[index]) {
                        globalApi.listCartSelect.add(globalApi.listCart[index]);
                      } else {
                        globalApi.listCartSelect
                            .remove(globalApi.listCart[index]);
                      }
                    }
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.rectangle,
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    listCheck[index] = !listCheck[index];
                    if (globalApi.listCartSelect != []) {
                      if (listCheck[index]) {
                        globalApi.listCartSelect.add(globalApi.listCart[index]);
                      } else {
                        globalApi.listCartSelect
                            .remove(globalApi.listCart[index]);
                      }
                    }
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
        SizedBox(
          width: 10,
        ),
        Image.network(
          product?.images?.first.url ??
              "https://loremflickr.com/640/480/fashion",
          width: 100,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product?.name ?? '--',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                cart.priceAfterDiscount?.formatMoney ?? '--',
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                cart.size ?? '--',
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        _quantityButton(product!, index)
      ]),
    );
  }

  Widget _quantityButton(Product product, index) {
    print(
        "NUMBER == ${listNumberQuantity[index]} \t ${product.id}  \t ${globalApi.listCart[index].quantity}  \t ${globalApi.listCart[index].size}  \t ${globalApi.listCart[index].productSizeId} \t ${globalApi.listCart[index].priceAfterDiscount}");
    cart
      ..idProduct = product!.id
      ..quantity = globalApi.listCart[index].quantity
      ..numberQuantityBuy = listNumberQuantity[index]
      ..size = globalApi.listCart[index].size
      ..productSizeId = globalApi.listCart[index].productSizeId
      ..percent = product.discount!.length > 0 ? product.discount![0].percent : 0
      ..priceAfterDiscount = globalApi.listCart[index].priceAfterDiscount
      ..product = product;

    globalApi.listCart.insert(index, cart);
    print("CHECK ADD ${globalApi.listCart[index].numberQuantityBuy}");
    const Color buttonColor = AppColors.primay;
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (listNumberQuantity[index] < 2) {
                setState(() {
                  listNumberQuantity == 1;
                });
              } else {
                setState(() {
                  listNumberQuantity[index]--;
                });
              }
            },
            icon: const Text('-'),
            iconSize: 10,
            splashRadius: 12,
          ),
          Text('${listNumberQuantity[index]}'),
          IconButton(
            onPressed: () {
              setState(() {
                listNumberQuantity[index]++;
              });
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

  String getTotalPrice() {
    int total = 0;
    for (int i = 0; i < listCheck.length; i++) {
      if (listCheck[i]) {
        total +=
            globalApi.listCart[i].priceAfterDiscount! * listNumberQuantity[i];
      }
    }
    return total.formatMoney;
  }
}
