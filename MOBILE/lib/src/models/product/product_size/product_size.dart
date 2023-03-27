import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../category/category.dart';
import '../product.dart';
part 'product_size.g.dart';

@JsonSerializable()
class ProductSize {
  int? id;
  int? quantity;
  Category? size;
  Product? product;
  ProductSize({
    this.id,
    this.quantity,
    this.size,
    this.product
  });
  factory ProductSize.fromJson(Map<String, dynamic> json) => _$ProductSizeFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSizeToJson(this);
}
