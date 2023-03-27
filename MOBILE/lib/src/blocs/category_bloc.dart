
import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/repositories/category_repo.dart';
import 'package:rxdart/rxdart.dart';

import '../models/category/category.dart';

class CategoryBloc extends BaseBloC{

  final BehaviorSubject<List<Category>> _categoryController = BehaviorSubject<List<Category>>();
  Stream<List<Category>> get categoryStream => _categoryController.stream;
  final CategoryRepository categoryRepository = CategoryRepository();


  void getListCategory() async{
    List<Category> listCategory = await categoryRepository.getListCategory();
    _categoryController.add(listCategory);
  }



  @override
  void dispose() {
    _categoryController.close();
  }

}