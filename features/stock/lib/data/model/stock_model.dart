import 'dart:convert';

List<StockModel> stockModelFromJson(String str) =>
    List<StockModel>.from(json.decode(str).map((x) => StockModel.fromJson(x)));

String stockModelToJson(List<StockModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockModel {
  int? stockId;
  int? stockProductId;
  int? stockQty;
  DateTime? stockCreatedAt;
  int? productId;
  String? productName;
  int? productPrice;
  String? productImage;
  int? productCategoryId;
  DateTime? productCreatedAt;
  String? categoryName;

  StockModel({
    this.stockId,
    this.stockProductId,
    this.stockQty,
    this.stockCreatedAt,
    this.productId,
    this.productName,
    this.productPrice,
    this.productImage,
    this.productCategoryId,
    this.productCreatedAt,
    this.categoryName,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
        stockId: json["stock_id"],
        stockProductId: json["stock_product_id"],
        stockQty: json["stock_qty"],
        stockCreatedAt: json["stock_created_at"] == null
            ? null
            : DateTime.parse(json["stock_created_at"]),
        productId: json["product_id"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productImage: json["product_image"],
        productCategoryId: json["product_category_id"],
        productCreatedAt: json["product_created_at"] == null
            ? null
            : DateTime.parse(json["product_created_at"]),
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "stock_id": stockId,
        "stock_product_id": stockProductId,
        "stock_qty": stockQty,
        "stock_created_at": stockCreatedAt?.toIso8601String(),
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_image": productImage,
        "product_category_id": productCategoryId,
        "product_created_at": productCreatedAt?.toIso8601String(),
        "category_name": categoryName,
      };
}
