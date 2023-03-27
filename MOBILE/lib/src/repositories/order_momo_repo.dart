
import 'package:base_code/src/api/global_api.dart';
import 'package:base_code/src/models/order_momo/order_momo.dart';
import 'package:base_code/src/struct/api_services/base_api.dart';
import 'package:base_code/src/struct/api_services/order_url.dart';

import '../struct/api_services/product_url.dart';

class OrderMomoRepository{
  final BaseApi _baseApi = BaseApi();

  Future<List<OrderMomo>> getListProduct({int page = 1}) async {
    var respond =
        await _baseApi.getMethod("${OrderUrl.orderMine}?page=$page");
    globalApi.totalPageOrderMomo = respond['data']['meta']['totalPages'];
    if (respond['success']) {
      return (respond['data']['items'] as List)
          .map((json) => OrderMomo.fromJson(json))
          .toList();
    } else {
      throw 'Server Error';
    }
  }

  Future<OrderMomo> getProductDetail({required String id}) async {
    String url = '${OrderUrl.orderDetail}/$id';
    var respond = await _baseApi.getMethod(url);
    if (respond['success']) {
      //TODO
      var data = (respond['data']);
      return OrderMomo.fromJson(data);
    } else {
      throw 'Server Error';
    }
  }
}