
import 'package:flutter/material.dart';

import '../models/cart.dart';


GlobalApi globalApi = GlobalApi();
class GlobalApi with ChangeNotifier{
  GlobalApi();
  List<Cart> listCart = [];
  List<Cart> listCartSelect = [];
  int? totalPageOrderMomo = 0;
}