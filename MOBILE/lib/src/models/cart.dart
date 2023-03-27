
import 'package:base_code/src/models/product/product.dart';

class Cart{
  String? idProduct;
  int? quantity;
  int? numberQuantityBuy;
  String? size;
  int? productSizeId;
  int? percent;
  int? priceAfterDiscount;
  Product? product;

  Cart({
    this.idProduct,
    this.quantity,
    this.numberQuantityBuy,
    this.size,
    this.productSizeId,
    this.percent,
    this.priceAfterDiscount,
    this.product
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        idProduct: json['id_product'],
        quantity: json['quantity'],
        numberQuantityBuy: json['number_buy'],
        size: json['size'],
        productSizeId: json['product_size_id'],
        percent: json['percent'],
        priceAfterDiscount: json['price_after_discount'],
        product: Product.fromJson(Map<String, dynamic>.from(json['product']))
    );

    Map<String, dynamic> toJson() => {
        "id_product": idProduct,
        "quantity": quantity,
        "number_buy": numberQuantityBuy,
        "size": size,
        "product_size_id": productSizeId,
        "percent": percent,
        "price_after_discount": priceAfterDiscount,
        "product": product?.toJson(),  
    };
}