import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/api_services/base_api.dart';
import 'package:base_code/src/struct/api_services/product_url.dart';

class ProductRepository {
  final BaseApi _baseApi = BaseApi();
  Future<List<Product>> getListProduct(
      [String search = '',
      bool isCheckLatest = false,
      int sortAssending = 0]) async {
    Map<String, dynamic> params = {};
      
      params.addAll({
      'filter': search != "" ? "category|\$eq|$search" : "",
      'sort': isCheckLatest ? "createdAt" : "",
      'sort': sortAssending == 0 ? "price" : "-price"
    });

    var respond =
        await _baseApi.getMethod(ProductUrl.listProduct, param: params);
    if (respond['success']) {

      return (respond['data']['items'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw 'Server Error';
    }
  }

  Future<List<Product>> getListProductSearch([String search = '']) async {
    Map<String, dynamic> params = {};
    if (search.isNotEmpty) {
      params.addAll({'search': search});
    }
    var respond =
        await _baseApi.getMethod(ProductUrl.listProduct, param: params);
    if (respond['success']) {
      return (respond['data']['items'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw 'Server Error';
    }
  }

  Future<Product> getProductDetail({required String slug}) async {
    String url = '${ProductUrl.getProductById}/$slug';

    var respond = await _baseApi.getMethod(url, param: {});
    if (respond['success']) {
      //TODO
      var data = (respond['data']);
      print("DDDDDDD ${data['discount']}");
      return Product.fromJson(data);
    } else {
      throw 'Server Error';
    }
  }
}
