import 'dart:async';
import 'dart:convert';

import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBloC extends BaseBloC {
  late SharedPreferences pref;

  final StreamController<List<Product>> _listCartController =
      StreamController<List<Product>>();
  Stream<List<Product>> get listCartStream => _listCartController.stream;
  CartBloC();

  void init() async {
    // pref = await SharedPreferences.getInstance();
    // pref.remove('listCart');
  }

  void getInCartProduct() async {
    // pref = await SharedPreferences.getInstance();
    // String? jsonProducts = pref.getString('listCart');
    // jsonProducts ??= '[]';
    // List listMapProduct = (json.decode(jsonProducts));
    // List<Product> listProduct =
    //     listMapProduct.map((json) => Product.fromJson(json)).toList();
    // _listCartController.add(listProduct);
  }

  @override
  void dispose() {}
}
