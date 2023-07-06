import 'dart:convert';

import 'package:common/model/product_model.dart';

class StockModel {
  final int? id;
  final int? productId;
  final int? qty;
  final DateTime? createdAt;
  final ProductModel? product;

  StockModel({
    this.id,
    this.productId,
    this.qty,
    this.createdAt,
    this.product,
  });

  factory StockModel.fromRawJson(String str) =>
      StockModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
        id: json["id"],
        productId: json["product_id"],
        qty: json["qty"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "qty": qty,
        "created_at": createdAt?.toIso8601String(),
        "product": product?.toJson(),
      };
}
