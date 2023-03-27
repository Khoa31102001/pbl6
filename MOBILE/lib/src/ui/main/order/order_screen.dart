// ignore_for_file: prefer_const_constructors

import 'package:base_code/src/blocs/cart_bloc.dart';
import 'package:base_code/src/blocs/order_bloc.dart';
import 'package:base_code/src/models/deliver_infomation/deliver_information.dart';
import 'package:base_code/src/models/order.dart';
import 'package:base_code/src/models/order_momo/order_momo.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/auth/login_screen.dart';
import 'package:base_code/src/ui/main/main.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:base_code/src/utils/integer_extension.dart';
import 'package:base_code/src/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/global_api.dart';
import '../../../blocs/order_momo_bloc.dart';
import '../../../commons/screens/error_screen.dart';
import '../../../manager/user_manager.dart';
import '../../../models/cart.dart';
import '../../../repositories/order_repo.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_strings.dart';
import '../common/app_bar.dart';
import '../momo_webview/momo_screen.dart';
import '../product/widget/icon_text_button.dart';

class OrderScreen extends StatefulWidget {
  int? id;
  OrderScreen({Key? key, this.id}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController edtName = TextEditingController();
  final TextEditingController edtPhone = TextEditingController();
  final TextEditingController edtAddress = TextEditingController();
  final TextEditingController edtNote = TextEditingController();
  int page = 0;
  PageController controller = PageController(initialPage: 0);
  DeliverInformation deliver = DeliverInformation();
  late CartBloC bloC;
  late OrderBloc orderBloc;
  List<int> listNumberQuantity = [];
  late SharedPreferences pref;
  late Order order = Order();
  List<Item> items = [];
  List<Item> itemsOrder = [];
  final OrderRepository _orderRepository = OrderRepository();
  String? url;
  String? urlPayment;
  late OrderMomoBloc _orderMomoBloc;
  int? idOrderMomo;
  OrderMomo? orderMomo;
  double priceDiscount = 0;
  // List<Product> cartProducts = [];
  Future postOrder() async {
    url = await _orderRepository.postOrder(order: order);
  }

  Future getPayment(int idOrder) async {
    urlPayment = await _orderRepository.getPayment(idOrder: idOrder);
  }

  void removeListCart() async {
    pref = await SharedPreferences.getInstance();
    pref.remove('listCart');
  }

  @override
  void initState() {
    idOrderMomo = widget.id;

    for (Cart i in globalApi.listCartSelect) {
      listNumberQuantity.add(i.numberQuantityBuy!);
      // cartProducts.add(i.product!);
      var item =
          Item(productSizeId: i.productSizeId, quantity: i.numberQuantityBuy);
      items.add(item);
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    deliver = DeliverInformation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     
            return Scaffold(
                appBar: customAppbar,
                body: Stack(
                  children: [
                    Container(
                      color: AppColors.pinkLight,
                    ),
                    PageView(
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        setState(() {
                          page = value;
                        });
                      },
                      children: [_pageInput(), _pageInforOrder()],
                      controller: controller,
                    )
                  ],
                ));
          
  
  }

  Widget _pageInput() {
    return Provider<OrderMomoBloc>(
      create: (context) => OrderMomoBloc(),
      builder: (context, child) {
        _orderMomoBloc = context.read<OrderMomoBloc>();
        _orderMomoBloc.getDetailOrderMomo(idOrderMomo.toString());
        return StreamBuilder<OrderMomo>(
            stream: _orderMomoBloc.orderMomoDetailStream,
            builder: (context, snapshot) {
              orderMomo = snapshot.data;
              // if (snapshot.connectionState == ConnectionState.waiting){
              //   return loadingWidget;
              // }
              if (orderMomo != null || globalApi.listCartSelect.length > 0) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100,
                        child: Text(
                          AppStrings.order,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          AppStrings.deliveryInformation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _inputInformation(
                          orderMomo != null
                              ? orderMomo!.name!
                              : "${AppStrings.name} *",
                          edtName,
                          TextInputType.text,
                          orderMomo),
                      _inputInformation(
                          orderMomo != null
                              ? orderMomo!.phone!
                              : "${AppStrings.phoneNumber} *",
                          edtPhone,
                          TextInputType.phone,
                          orderMomo),
                      _inputInformation(
                          orderMomo != null
                              ? orderMomo!.address!
                              : "${AppStrings.address} *",
                          edtAddress,
                          TextInputType.text,
                          orderMomo),
                      _inputInformation(
                          orderMomo == null
                              ? AppStrings.note
                              : orderMomo?.note != null
                                  ? orderMomo?.note
                                  : "",
                          edtNote,
                          TextInputType.text,
                          orderMomo),
                      _nextPageInforOrder(orderMomo)
                    ],
                  ),
                );
              } else
                return Image.asset(AppImages.cartEmpty);
            });
      },
    );
  }

  Widget _inputInformation(String hintText, TextEditingController controller,
      TextInputType type, OrderMomo? orderMomo) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
      child: Container(
        child: TextField(
          enabled: orderMomo != null ? false : true,
          keyboardType: type,
          decoration:
              InputDecoration(border: OutlineInputBorder(), hintText: hintText),
          controller: controller,
        ),
      ),
    );
  }

  Widget _nextPageInforOrder(OrderMomo? orderMomo) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Main(),
                )),
            child: Text(AppStrings.cancelOrder),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (orderMomo != null) {
                    setState(() {
                      page++;
                      controller.animateToPage(page,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    });
                  } else {
                    if (edtName.text.isEmpty ||
                        edtAddress.text.isEmpty ||
                        edtPhone.text.isEmpty) {
                      showErrorDialog(context, AppStrings.inputInformation);
                    } else {
                      deliver
                        ..name = edtName.text.toString()
                        ..address = edtAddress.text.toString()
                        ..phoneNumber = edtPhone.text.toString()
                        ..note = edtNote.text.toString();

                      setState(() {
                        page++;
                        controller.animateToPage(page,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      });
                      print(
                          "AAAAAAA ${globalApi.listCartSelect.length} \t ${globalApi.listCartSelect.length}");
                      for (int i = 0;
                          i < globalApi.listCartSelect.length;
                          i++) {
                        print(
                            "AAAAAAA2 ${globalApi.listCartSelect[i].product!.price!} \t ${globalApi.listCartSelect[i].priceAfterDiscount!} \t $priceDiscount");

                        if (globalApi.listCartSelect[i].product!.price! >
                            globalApi.listCartSelect[i].priceAfterDiscount!) {
                          priceDiscount += globalApi
                                  .listCartSelect[i].product!.price! -
                              globalApi.listCartSelect[i].priceAfterDiscount!;
                        }
                      }
                    }
                  }
                },
                child: Text(
                  AppStrings.next,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _pageInforOrder() {
    if (orderMomo != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 100,
              child: Text(
                AppStrings.order,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                "${AppStrings.order} (${orderMomo!.orderItems!.length} products)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            _listOrderMomo(orderMomo!.orderItems!,
                int.parse(orderMomo!.total!.stringSplitZero)),
            SizedBox(
              height: 10,
            ),
            _lineHeight(),
            _inforPrice(
                AppStrings.price,
                int.parse(orderMomo!.total!.stringSplitZero).formatMoney,
                FontWeight.w500),
            _inforPrice(
                AppStrings.discount,
                (int.parse(orderMomo!.total!) -
                        orderMomo!.orderItems![0].price!)
                    .formatMoney,
                FontWeight.w500),
            _inforPrice(AppStrings.ship, "20.000 đ", FontWeight.w500),
            _inforPrice(
                AppStrings.total,
                orderMomo!.orderItems![0].price!
                    .formatMoney,
                FontWeight.w700),
            _lineHeight(),
            _backInforInputMomo(orderMomo),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10, bottom: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Main(),
                      )),
                  child: Text(AppStrings.cancelOrder),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      String totalPrice = getTotalPrice(globalApi.listCartSelect);
      String totalPriceAfterDiscount =
          getTotalPriceAfterDiscount(globalApi.listCartSelect);

      return globalApi.listCartSelect.length == 0
          ? Image.asset(AppImages.cartEmpty)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 100,
                    child: Text(
                      AppStrings.order,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      "${AppStrings.order} (${globalApi.listCartSelect.length} products)",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  _listOrder(globalApi.listCartSelect),
                  SizedBox(
                    height: 10,
                  ),
                  _lineHeight(),
                  _inforPrice(AppStrings.price, totalPrice, FontWeight.w500),
                  _inforPrice(AppStrings.discount, "${priceDiscount.toInt()}",
                      FontWeight.w500),
                  _inforPrice(AppStrings.ship, "20.000 đ", FontWeight.w500),
                  _inforPrice(AppStrings.total, totalPriceAfterDiscount,
                      FontWeight.w700),
                  _lineHeight(),
                  _backInforInput(),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10, bottom: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Main(),
                            )),
                        child: Text(AppStrings.cancelOrder),
                      ),
                    ),
                  ),
                ],
              ),
            );
    }
  }

  Widget _listOrder(List<Cart> listCart) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: listCart.length,
          itemBuilder: (context, index) {
            var product = listCart[index].product!;
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image.network(
                          product.images?.first.url ??
                              "https://loremflickr.com/640/480/fashion",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 55),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "${listCart[index].numberQuantityBuy}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '--',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        listCart[index].size ?? '--',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    (listCart[index].numberQuantityBuy! * product.price!)
                            .formatMoney ??
                        '--',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            );
          },
        ));
  }

  Widget _listOrderMomo(List<OrderItem> orderItems, int money) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: orderItems.length,
          itemBuilder: (context, index) {
            OrderItem orderItem = orderItems[index];
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image.network(
                          orderItem.productSize?.product!.images!.first.url ??
                              "https://loremflickr.com/640/480/fashion",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 55),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            orderItem.quantity.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderItem.productSize?.product!.images!.first.name ??
                            '--',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        orderItem.productSize?.size!.name ?? '--',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    money.formatMoney,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            );
          },
        ));
  }

  Widget _inforPrice(String text, String price, FontWeight fontWeight) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            price,
            style: TextStyle(fontSize: 20, fontWeight: fontWeight),
          ),
        ],
      ),
    );
  }

  Widget _lineHeight() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.black,
    );
  }

  Widget _backInforInputMomo(OrderMomo? orderMomo) {
    itemsOrder = [];
    for (var i in orderMomo!.orderItems!) {
      var item = Item(
          productSizeId: i.productSizeId,
          quantity: i.quantity);
      itemsOrder.add(item);
    }
    order
      ..items = itemsOrder
      ..address = orderMomo.address
      ..name = orderMomo.name
      ..phone = orderMomo.phone
      ..note = orderMomo.note;

    print(
        "ORDERBUILD== ${order.items?.length} \t ${order.name} \t ${order.phone} \t ${order.address}");
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    page--;
                    controller.animateToPage(page,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  });
                },
                child: Text(
                  AppStrings.prev,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          ),
          Visibility(
            visible: orderMomo.status != 'cancelled',
            child: IconTextButton(
                imageUrl: AppImages.wallet,
                title: AppStrings.checkout,
                onTap: () async {
                  try {
                    await getPayment(idOrderMomo!);
                    print("URL == $url \t ${UserManager.globalToken}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MomoScreen(url: urlPayment),
                        )).then((value) {
                      globalApi.listCartSelect = [];
                      setState(() {});
                    });
                  } catch (error, stackStrace) {
                    debugPrint(error.toString());
                    debugPrintStack(stackTrace: stackStrace);
                    showErrorDialog(context, error);
                  }

                  setState(() {});
                }),
          )
        ],
      ),
    );
  }

  Widget _backInforInput() {
    order
      ..items = items
      ..address = deliver.address
      ..name = deliver.name
      ..phone = deliver.phoneNumber
      ..note = deliver.note;

    print(
        "ORDERBUILD== ${order.items?.length} \t ${order.name} \t ${order.phone} \t ${order.address}");
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    page--;
                    controller.animateToPage(page,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  });
                },
                child: Text(
                  AppStrings.prev,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          ),
          IconTextButton(
              imageUrl: AppImages.wallet,
              title: AppStrings.checkout,
              onTap:  () async {
                try {
                  await postOrder();
                  for (var element in globalApi.listCartSelect) {
                    globalApi.listCart.remove(element);
                  }
                  removeListCart();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MomoScreen(url: url),
                      )).then((value) {});
                  globalApi.listCartSelect = [];
                  setState(() {});
                } catch (error, stackStrace) {
                  debugPrint(error.toString());
                  debugPrintStack(stackTrace: stackStrace);
                  showErrorDialog(context, error);
                }

                setState(() {});
              })
        ],
      ),
    );
  }

  String getTotalPrice(List<Cart> list) {
    int total = 0;
    for (int i = 0; i < list.length; i++) {
      total += list[i].product!.price! * listNumberQuantity[i];
    }
    return total.formatMoney;
  }

  String getTotalPriceAfterDiscount(List<Cart> list) {
    int total = 0;
    for (int i = 0; i < list.length; i++) {
      total += list[i].product!.price! * listNumberQuantity[i];
    }
    return (total - priceDiscount.toInt() + 20000).formatMoney;
  }
}
