part of 'discount.dart';

extension DiscountCopyWith on Discount {
  Discount copyWith({
    int? id,

    String? name,
    int? percent,

  }) {
    return Discount(
        id: id ?? this.id,

        name: name ?? this.name,
        percent: percent ?? this.percent,
);
  }
}

Discount _$DiscountFromJson(Map json) {
  return Discount(
    id: json['id'] as int?,

    name: json["name"],
    percent: json["percent"] as int?,

  );
}

Map<String, dynamic> _$DiscountToJson(Discount instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull("id", instance.id);

  writeNotNull("name", instance.name);
  writeNotNull("percent", instance.percent);

  return val;
}
