import 'package:json_annotation/json_annotation.dart';
part 'discount.g.dart';

@JsonSerializable()
class Discount {
  Discount({
    this.id,

    this.name,
    this.percent,

  });

  int? id;

  String? name;
  int? percent;

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);
  Map toJson() => _$DiscountToJson(this);
}
