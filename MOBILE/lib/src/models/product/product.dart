import 'package:json_annotation/json_annotation.dart';

import 'category/category.dart';
import 'discount/discount.dart';
import 'product_size/product_size.dart';
part 'product.g.dart';
@JsonSerializable()
class Product {
  String? id;
  String? name;
  String? slug;
  String? description;
  int? price;
  String? unit;
  String? status;
  int? stock;
  Category? category;
  List<ProductSize>? productSizes;
  List<Category>? images;
  List<Discount>? discount;


  Product({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.price,
    this.unit,
    this.status,
    this.stock,
    this.category,
    this.productSizes,
    this.images,
    this.discount
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map toJson() => _$ProductToJson(this);
}
