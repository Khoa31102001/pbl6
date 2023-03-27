

class Order {
    Order({
        this.items,
        this.address,
        this.name,
        this.phone,
        this.note,
    });

    List<Item>? items;
    String? address;
    String? name;
    String? phone;
    String? note;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        address: json["address"],
        name: json["name"],
        phone: json["phone"],
        note: json["note"],
    );

    Map<String, dynamic> toJson() => orderToJson(this);
}
Map<String, dynamic> orderToJson(Order instance){
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('items', instance.items);
  writeNotNull('address', instance.address);
  writeNotNull('name', instance.name);
  writeNotNull('phone', instance.phone);
  writeNotNull('note', instance.note);
  return val;
}

class Item {
    Item({
        this.productSizeId,
        this.quantity,
    });

    int? productSizeId;
    int? quantity;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        productSizeId: json["productSizeId"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => itemToJson(this);
}

Map<String, dynamic> itemToJson(Item instance){
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('productSizeId', instance.productSizeId);
  writeNotNull('quantity', instance.quantity);
  return val;
}