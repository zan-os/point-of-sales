import 'dart:convert';

class ProductListModel {
    final int? id;
    final String? name;
    final int? price;
    final String? image;
    final int? categoryId;
    final DateTime? createdAt;
    final int? qty;

    ProductListModel({
        this.id,
        this.name,
        this.price,
        this.image,
        this.categoryId,
        this.createdAt,
        this.qty,
    });

    factory ProductListModel.fromRawJson(String str) => ProductListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        qty: json["qty"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "category_id": categoryId,
        "created_at": createdAt?.toIso8601String(),
        "qty": qty,
    };
}
