import 'package:base_code/src/commons/widgets/rounded_image.dart';
import 'package:base_code/src/models/product/category/category.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:base_code/src/ui/main/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:base_code/src/utils/integer_extension.dart';
class ProductItem extends StatelessWidget {
  const ProductItem({required this.url, required this.product, Key? key})
      : super(key: key);
  final String url;
  final Product product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxWidth,
                      child: RoundedImage(url: url),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      product.name ?? '--',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${product.price?.formatMoney}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                   
                  ]);
            }),
          ],
        ),
      ),
    );
  }
}
