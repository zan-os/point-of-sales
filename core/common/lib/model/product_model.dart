import 'dart:convert';

class ProductModel {
  final int? id;
  final String? name;
  final int? price;
  final String? image;
  final int? categoryId;
  final DateTime? createdAt;
  ProductModel({
    this.id,
    this.name,
    this.price,
    this.image,
    this.categoryId,
    this.createdAt,
  });

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "category_id": categoryId,
        "created_at": createdAt?.toIso8601String(),
      };
}
