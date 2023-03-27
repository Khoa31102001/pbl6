part of 'product.dart';

extension ProductCopyWith on Product {
  Product copyWith(
      {String? id,
      String? name,
      String? slug,
      String? description,
      int? price,
      String? unit,
      String? status,
      int? stock,
      Category? category,
      List<ProductSize>? productSizes,
      List<Category>? images,
      List<Discount>? discount}) {
    return Product(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        description: description ?? this.description,
        price: price ?? this.price,
        unit: unit ?? this.unit,
        status: status ?? this.status,
        stock: stock ?? this.stock,
        category: category ?? this.category,
        productSizes: productSizes ?? this.productSizes,
        images: images ?? this.images,
        discount: discount ?? this.discount);
  }
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json["id"].toString(),
    name: json["name"] as String?,
    slug: json["slug"] as String?,
    description: json["description"] as String?,
    price: json["price"] as int?,
    unit: json["unit"] as String?,
    status: json["status"] as String?,
    stock: json["stock"] as int?,
    category: json['category'] == null
        ? null
        : Category.fromJson(Map<String, dynamic>.from(json['category'] as Map)),
    productSizes: (json['productSizes'] as List<dynamic>?)
        ?.map((e) => ProductSize.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    images: (json['images'] as List<dynamic>?)
        ?.map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    discount: (json['discount'] as List<dynamic>)
        .map((e) => Discount.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull("id", instance.id);
  writeNotNull("name", instance.name);
  writeNotNull("slug", instance.slug);
  writeNotNull("description", instance.description);
  writeNotNull("price", instance.price);
  writeNotNull("unit", instance.unit);
  writeNotNull("status", instance.status);
  writeNotNull("stock", instance.stock);
  writeNotNull("category", instance.category);
  writeNotNull("productSizes", instance.productSizes);
  writeNotNull("images", instance.images);
  writeNotNull("discount", instance.discount);

  return val;
}
