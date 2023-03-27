import '../../product/product_size/product_size.dart';

class OrderItem {
    OrderItem({
        this.id,
        this.productSizeId,
        this.quantity,
        this.price,
        this.total,
        this.productSize,
    });

    int? id;
    int? productSizeId;
    int? quantity;
    int? price;
    String? total;
    ProductSize? productSize;

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
       
        productSizeId: json["productSizeId"],
        quantity: json["quantity"],
        price: json["price"],
        total: json["total"],
        productSize: ProductSize.fromJson(json["productSize"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productSizeId": productSizeId,
        "quantity": quantity,
        "price": price,
        "total": total,
        "productSize": productSize?.toJson(),
    };
}