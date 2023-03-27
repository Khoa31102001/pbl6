part of 'category.dart';

extension CategoryCopyWith on Category {
  Category copyWith({
    int? id,
    String? name,
    String? url,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url
    );
  }
}

Category _$CategoryFromJson(Map json){
  return Category(
    id: json['id'] as int?,
    name: json['name'] as String?,
    url: json['url'] as String?
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance){
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value){
    if(value != null){
      val[key] = value;
    }
  }
  
  writeNotNull("id", instance.id);
  writeNotNull("name", instance.name);
  writeNotNull("url", instance.url);
  return val;
}