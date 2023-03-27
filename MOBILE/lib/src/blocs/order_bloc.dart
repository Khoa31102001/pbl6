
import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/repositories/order_repo.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../models/order.dart';

class OrderBloc extends BaseBloC{

  final OrderRepository _orderRepository = OrderRepository();
  final BehaviorSubject<String> _orderController =
      BehaviorSubject<String>();
  Stream<String> get orderStream => _orderController.stream;

  void init (){
  }

  void postOrder({required Order order}) async{
    try{
      String url = await _orderRepository.postOrder(order: order);
      _orderController.add(url);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

}