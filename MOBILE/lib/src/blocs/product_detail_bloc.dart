import 'dart:convert';

import 'package:base_code/src/api/global_api.dart';
import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/models/cart.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/repositories/product_repo.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/toast_utils.dart';

class ProductDetailBloC extends BaseBloC {
  final ProductRepository _productRepository = ProductRepository();
  final BehaviorSubject<Product> _productController =
      BehaviorSubject<Product>();
  Stream<Product> get productStream => _productController.stream;
  List<Cart> listCart = [];
  bool isCheckUpdate = false;
  int? indexCart;
  int? numberBuyBefore;
  Cart cart = Cart();

  void init({required Product product}) {
    _productController.add(product);
  }

  void getProductDetail({required String slug}) async {
    try {
      Product product = await _productRepository.getProductDetail(slug: slug);
      _productController.add(product);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void addToCart(Product product, int quantity, int numberQuantityBuy,
      String size, int productSizeId, int priceAfterDiscount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonProducts = pref.getString('listCart');
    jsonProducts ??= '[]';
    List listMapProduct = (json.decode(jsonProducts));
    for (int i = 0; i < globalApi.listCart.length; i++) {
      if (globalApi.listCart[i].idProduct == product.id && globalApi.listCart[i].size == size ) {
        isCheckUpdate = true;
        indexCart = i;
        numberBuyBefore = globalApi.listCart[i].numberQuantityBuy;
      }
    }
    if (!isCheckUpdate) {
      cart
        ..idProduct = product.id
        ..quantity = quantity
        ..numberQuantityBuy = numberQuantityBuy
        ..size = size
        ..productSizeId = productSizeId
        ..percent = product.discount!.length > 0 ? product.discount![0].percent : 0
        ..priceAfterDiscount = priceAfterDiscount
        ..product = product;

      // listMapProduct.add(product.toJson());
      globalApi.listCart.add(cart);
    listMapProduct.add(cart.toJson());
    pref.setString('listCart', json.encode(listMapProduct));
      ToastUtils.showToast(AppStrings.addToCartSuccess);
    }else {
      globalApi.listCart.remove(globalApi.listCart[indexCart!]);
      cart
        ..idProduct = product.id
        ..quantity = quantity
        ..numberQuantityBuy = (numberQuantityBuy + numberBuyBefore!)
        ..size = size
        ..productSizeId = productSizeId
        ..percent = product.discount!.length > 0 ? product.discount![0].percent : 0
        ..priceAfterDiscount = priceAfterDiscount
        ..product = product;
      globalApi.listCart.insert(indexCart!,cart);
      ToastUtils.showToast(AppStrings.updateCartSuccess);
    }
  }

  @override
  void dispose() {}
}
