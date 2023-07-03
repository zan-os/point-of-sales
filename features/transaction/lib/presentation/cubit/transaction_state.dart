import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:transaction/data/model/transaction_detail/transaction_detail_model.dart';

class TransactionState extends Equatable {
  final CubitState status;
  final String userId;
  final String message;
  final int totalBill;
  final List<TransactionDetailModel> transactionDetail;

  const TransactionState(
      {this.totalBill = 0,
      this.userId = '',
      this.status = CubitState.initial,
      this.message = '',
      this.transactionDetail = const []});

  TransactionState copyWith({
    CubitState? status,
    String? userId,
    int? totalBill,
    String? message,
    List<TransactionDetailModel>? transactionDetail,
  }) {
    return TransactionState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      totalBill: totalBill ?? this.totalBill,
      message: message ?? this.message,
      transactionDetail: transactionDetail ?? this.transactionDetail,
    );
  }

  @override
  List<Object?> get props =>
      [status, totalBill, message, transactionDetail, userId];
}
