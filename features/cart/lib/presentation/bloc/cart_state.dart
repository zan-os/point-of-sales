import 'package:cart/data/cart_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class CartState extends Equatable {
  final CubitState status;
  final String totalBill;
  final List<CartModel> cartDetail;

  const CartState( {this.totalBill = '',
    this.status = CubitState.initial,
    this.cartDetail = const [],
  });

  CartState copyWith({
    CubitState? status,
    List<CartModel>? cartDetail,
    String? totalBill,
  }) {
    return CartState(
      status: status ?? this.status,
      cartDetail: cartDetail ?? this.cartDetail,
      totalBill: totalBill ??this.totalBill
    );
  }

  @override
  List<Object?> get props => [
        status,
        cartDetail,
        totalBill,
      ];
}
