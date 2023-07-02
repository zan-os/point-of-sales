import 'dart:convert';

import 'package:common/model/product_model.dart';

class CartModel {
    final int? id;
    final int? cartQty;
    final int? productPrice;
    final int? totalPrice;
    final ProductModel? product;

    CartModel({
        this.id,
        this.cartQty,
        this.productPrice,
        this.totalPrice,
        this.product,
    });

    factory CartModel.fromRawJson(String str) => CartModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        cartQty: json["cart_qty"],
        productPrice: json["product_price"],
        totalPrice: json["total_price"],
        product: json["product"] == null ? null : ProductModel.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cart_qty": cartQty,
        "product_price": productPrice,
        "total_price": totalPrice,
        "product": product?.toJson(),
    };
}