
import 'package:base_code/src/struct/api_services/base_api.dart';
import 'package:base_code/src/struct/api_services/category_url.dart';

import '../models/category/category.dart';

class CategoryRepository {
  final _baseApi = BaseApi();

  Future<List<Category>> getListCategory() async{
    var respond = await _baseApi.getMethod(CategoryUrl.categories);
   if (respond['success']) {
      return (respond['data']['items'] as List)
          .map((json) => Category.fromJson(json))
          .toList();
    } else {
      throw 'Server Error';
    }
  }
}