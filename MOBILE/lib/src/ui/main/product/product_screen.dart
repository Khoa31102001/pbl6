import 'package:base_code/src/blocs/product_screen_bloc.dart';
import 'package:base_code/src/commons/widgets/loading_widget.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/common/app_bar.dart';
import 'package:base_code/src/ui/main/home_screen/widgets/product_item.dart';
import 'package:base_code/src/utils/app_boxshadow.dart';
import 'package:base_code/src/utils/app_image.dart';
import 'package:base_code/src/utils/app_strings.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../blocs/category_bloc.dart';
import '../../../blocs/home_screen_bloc.dart';
import '../../../models/category/category.dart';

class ProductScreen extends StatefulWidget {
  bool?isCheckHomeToProduct;
  ProductScreen({Key? key, this.isCheckHomeToProduct}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductScreenBloC _bloC;
  late CategoryBloc _categoryBloc;
  bool isCheckLatest = false;
  String? selectedValue;
  List<String> itemsPriceAccending = ["Price ascending", "Price descending"];
  String selectPriceAssending = "Price ascending";
  GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    print("ISCHECH == ${widget.isCheckHomeToProduct}");
    return Scaffold(
      appBar: widget.isCheckHomeToProduct == null ? null : customAppbar,
      body: Provider<ProductScreenBloC>(
          create: (_) => ProductScreenBloC(),
          dispose: (_, bloc) => bloc.dispose(),
          builder: (context, _) {
            _bloC = context.read<ProductScreenBloC>();
            _bloC.getListProducts(selectedValue ?? "", isCheckLatest,
                selectPriceAssending == "Price ascending" ? 0 : 1);
            return Provider<CategoryBloc>(
              create: (_) => CategoryBloc(),
              dispose: (context, bloc) => bloc.dispose(),
              builder: (context, _) {
                _categoryBloc = context.read<CategoryBloc>();
                _categoryBloc.getListCategory();

                      return Container(
                        color: AppColors.pinkLight,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(children: [

                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 100, bottom: 50),
                                child: _searchBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _categoryAllItem(AppStrings.allCategories),
                                _categoryPriceItem(AppStrings.priceAscending)
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    child: GestureDetector(
                                        onTap: () => setState(() {
                                              isCheckLatest = !isCheckLatest;
                                            }),
                                        child: _categoryItem(AppStrings.latest,
                                            hasLogo: false))),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: 1,
                                  height: 15,
                                  color: AppColors.primay,
                                ),
                                Flexible(
                                    child: _categoryItem(AppStrings.bestSeller,
                                        hasLogo: false))
                              ],
                            ),
                            _productGridView(),
                            const SizedBox(
                              height: 30,
                            ),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () {},
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        AppImages.share,
                                        width: 24,
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      const Text(AppStrings.nextPage)
                                    ],
                                  ),
                                )),
                            const SizedBox(
                              height: 100,
                            ),
                          ]),
                        ),
                      );
                    });
              },
            ));
          

  }

  Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), boxShadow: boxShadows),
      child: TextField(
        onChanged: (value) {
          _bloC.searchSink.add(value);
        },
        style: const TextStyle(color: AppColors.secondary),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          fillColor: Colors.white,
          hintText: AppStrings.searchSomething,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AppImages.search,
              width: 40,
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _categoryAllItem(String title, {bool hasLogo = true}) {
    return StreamBuilder<List<Category>>(
        stream: _categoryBloc.categoryStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> categories = snapshot.data!;

            return DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                items: categories
                    .map((item) => DropdownMenuItem<String>(
                          value: item.name,
                          child: Text(
                            item.name!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                icon: Image.asset(
                  AppImages.dropdown,
                  width: 12,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.black,
                buttonHeight: 50,
                buttonWidth: 160,
                itemHeight: 40,
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
                dropdownPadding: null,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-20, 0),
              ),
            );
          }
          return loadingWidget;
        });
  }

  Widget _categoryPriceItem(String title, {bool hasLogo = true}) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        items: itemsPriceAccending.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        value: selectPriceAssending,
        onChanged: (value) {
          setState(() {
            selectPriceAssending = value as String;
          });
        },
        icon: Image.asset(
          AppImages.dropdown,
          width: 12,
        ),
        iconSize: 14,
        iconEnabledColor: Colors.black,
        buttonHeight: 50,
        buttonWidth: 160,
        itemHeight: 40,
        dropdownMaxHeight: 200,
        dropdownWidth: 200,
        dropdownPadding: null,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        offset: const Offset(-20, 0),
      ),
    );
  }

  Widget _categoryItem(String title, {bool hasLogo = true}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        const SizedBox(
          width: 5,
        ),
        if (hasLogo)
          Image.asset(
            AppImages.dropdown,
            width: 12,
          )
      ],
    );
  }

  Widget _productGridView() {
    return StreamBuilder<List<Product>?>(
        stream: _bloC.productStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product>? products = snapshot.data;
            print("Products ${products!.length}");
            if (products.isEmpty) {
              return Image.asset(
                AppImages.cartEmpty,
                width: 300,
                height: 300,
              );
            }
            return Container(
              margin: EdgeInsets.only(top: 30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 170 / 280,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return ProductItem(
                        url: products[index].images!.first.url!,
                        product: products[index],
                      );
                    }),
              ),
            );
          }
          return loadingWidget;
        });
  }
}
