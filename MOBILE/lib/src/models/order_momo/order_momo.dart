// To parse this JSON data, do
//
//     final orderMomo = orderMomoFromJson(jsonString);

import 'dart:convert';

OrderMomo orderMomoFromJson(String str) => OrderMomo.fromJson(json.decode(str));

String orderMomoToJson(OrderMomo data) => json.encode(data.toJson());

class OrderMomo {
    OrderMomo({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.userId,
        this.total,
        this.address,
        this.name,
        this.phone,
        this.note,
        this.orderItems,
    });

    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? status;
    int? userId;
    String? total;
    String? address;
    String? name;
    String? phone;
    dynamic note;
    List<OrderItem>? orderItems;

    factory OrderMomo.fromJson(Map<String, dynamic> json) => OrderMomo(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        status: json["status"],
        userId: json["userId"],
        total: json["total"],
        address: json["address"],
        name: json["name"],
        phone: json["phone"],
        note: json["note"],
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
        "userId": userId,
        "total": total,
        "address": address,
        "name": name,
        "phone": phone,
        "note": note,
        "orderItems": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
    };
}

class OrderItem {
    OrderItem({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.productSizeId,
        this.quantity,
        this.price,
        this.total,
        this.productSize,
    });

    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? productSizeId;
    int? quantity;
    int? price;
    int? total;
    ProductSize? productSize;

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        productSizeId: json["productSizeId"],
        quantity: json["quantity"],
        price: json["price"],
        total: json["total"],
        productSize: ProductSize.fromJson(json["productSize"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "productSizeId": productSizeId,
        "quantity": quantity,
        "price": price,
        "total": total,
        "productSize": productSize?.toJson(),
    };
}

class ProductSize {
    ProductSize({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.quantity,
        this.product,
        this.size,
    });

    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? quantity;
    Product? product;
    Size? size;

    factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        quantity: json["quantity"],
        product: Product.fromJson(json["product"]),
        size: Size.fromJson(json["size"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "quantity": quantity,
        "product": product?.toJson(),
        "size": size!.toJson(),
    };
}

class Product {
    Product({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.slug,
        this.description,
        this.price,
        this.unit,
        this.status,
        this.stock,
        this.images,
    });

    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? name;
    String? slug;
    String? description;
    int? price;
    String? unit;
    String? status;
    int? stock;
    List<Size>? images;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        price: json["price"],
        unit: json["unit"],
        status: json["status"],
        stock: json["stock"],
        images: List<Size>.from(json["images"].map((x) => Size.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "name": name,
        "slug": slug,
        "description": description,
        "price": price,
        "unit": unit,
        "status": status,
        "stock": stock,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
    };
}

class Size {
    Size({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.url,
    });

    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? name;
    String? url;

    factory Size.fromJson(Map<String, dynamic> json) => Size(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        url: json["url"] == null ? null : json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "name": name,
        "url": url == null ? null : url,
    };
}
