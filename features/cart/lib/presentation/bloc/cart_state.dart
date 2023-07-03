import 'package:cart/data/cart_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class CartState extends Equatable {
  final CubitState status;
  final String message;
  final int totalBill;
  final List<CartModel> cartDetail;

  const CartState( {this.totalBill = 0,
    this.status = CubitState.initial,
    this.message = '',
    this.cartDetail = const [],
  });

  CartState copyWith({
    CubitState? status,
    String? message,
    List<CartModel>? cartDetail,
    int? totalBill,
  }) {
    return CartState(
      status: status ?? this.status,
      message: message ?? this.message,
      cartDetail: cartDetail ?? this.cartDetail,
      totalBill: totalBill ??this.totalBill
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        cartDetail,
        totalBill,
      ];
}
