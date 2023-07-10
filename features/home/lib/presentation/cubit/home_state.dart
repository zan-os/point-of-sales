import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class HomeState extends Equatable {
  final CubitState status;
  final String message;
  final int totalProduct;
  final int outOfStockProduct;
  final int totalOrder;
  final int totalIncome;

  const HomeState({
    this.totalProduct = 0,
    this.outOfStockProduct = 0,
    this.totalOrder = 0,
    this.totalIncome = 0,
    this.status = CubitState.initial,
    this.message = '',
  });

  HomeState copyWith({
    CubitState? status,
    String? message,
    int? totalProduct,
    int? outOfStockProduct,
    int? totalOrder,
    int? totalIncome,
  }) {
    return HomeState(
      status: status ?? this.status,
      message: message ?? this.message,
      totalProduct: totalProduct ?? this.totalProduct,
      outOfStockProduct: outOfStockProduct ?? this.outOfStockProduct,
      totalOrder: totalOrder ?? this.totalOrder,
      totalIncome: totalIncome ?? this.totalIncome,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        totalProduct,
        outOfStockProduct,
        totalOrder,
        totalIncome,
      ];
}
