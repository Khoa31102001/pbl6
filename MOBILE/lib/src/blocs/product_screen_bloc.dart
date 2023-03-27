import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/repositories/product_repo.dart';
import 'package:rxdart/rxdart.dart';

const kSearchDebounceDuration = Duration(seconds: 1);

class ProductScreenBloC extends BaseBloC {
  final PublishSubject<String> _searchController = PublishSubject<String>();
  final BehaviorSubject<List<Product>?> _productController =
      BehaviorSubject<List<Product>?>();
  Stream<List<Product>?> get productStream => _productController.stream;
  Sink<String> get searchSink => _searchController.sink;
  final ProductRepository _productRepository = ProductRepository();

  ProductScreenBloC() {
    _searchController
        .debounce((_) => TimerStream(true, kSearchDebounceDuration))
        .listen((searchText) => _searchText(searchText));
  }
  void getListProducts(String search, bool isCheckLatest, int sortAssending) async {
    List<Product> products = await _productRepository.getListProduct(search, isCheckLatest, sortAssending);
    _productController.add(products);
  }


  void _searchText(String searchText) async {
    _productController.add(null);
    List<Product> products =
        await _productRepository.getListProductSearch(searchText);
    _productController.add(products);
  }

  @override
  void dispose() {
    _productController.close();
  }
}
