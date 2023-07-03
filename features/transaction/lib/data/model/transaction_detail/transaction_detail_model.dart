import 'dart:convert';

class TransactionDetailModel {
    final int id;
    final int transactionId;
    final int productId;
    final int qty;
    final int price;
    final DateTime createdAt;
    final Transaction transaction;
    final Product product;

    TransactionDetailModel({
        required this.id,
        required this.transactionId,
        required this.productId,
        required this.qty,
        required this.price,
        required this.createdAt,
        required this.transaction,
        required this.product,
    });

    factory TransactionDetailModel.fromRawJson(String str) => TransactionDetailModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TransactionDetailModel.fromJson(Map<String, dynamic> json) => TransactionDetailModel(
        id: json["id"],
        transactionId: json["transaction_id"],
        productId: json["product_id"],
        qty: json["qty"],
        price: json["price"],
        createdAt: DateTime.parse(json["created_at"]),
        transaction: Transaction.fromJson(json["transaction"]),
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_id": transactionId,
        "product_id": productId,
        "qty": qty,
        "price": price,
        "created_at": createdAt.toIso8601String(),
        "transaction": transaction.toJson(),
        "product": product.toJson(),
    };
}

class Product {
    final String name;
    final String image;

    Product({
        required this.name,
        required this.image,
    });

    factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
    };
}

class Transaction {
    final int id;
    final String orderId;
    final int transactionStatus;
    final int paymentTotal;
    final dynamic receivedPaymentTotal;
    final DateTime createdAt;
    final dynamic telephone;
    final dynamic address;
    final String userId;
    final dynamic table;

    Transaction({
        required this.id,
        required this.orderId,
        required this.transactionStatus,
        required this.paymentTotal,
        required this.receivedPaymentTotal,
        required this.createdAt,
        required this.telephone,
        required this.address,
        required this.userId,
        this.table,
    });

    factory Transaction.fromRawJson(String str) => Transaction.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        orderId: json["order_id"],
        transactionStatus: json["transaction_status"],
        paymentTotal: json["payment_total"],
        receivedPaymentTotal: json["received_payment_total"],
        createdAt: DateTime.parse(json["created_at"]),
        telephone: json["telephone"],
        address: json["address"],
        userId: json["user_id"],
        table: json["table"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "transaction_status": transactionStatus,
        "payment_total": paymentTotal,
        "received_payment_total": receivedPaymentTotal,
        "created_at": createdAt.toIso8601String(),
        "telephone": telephone,
        "address": address,
        "user_id": userId,
        "table": table,
    };
}
