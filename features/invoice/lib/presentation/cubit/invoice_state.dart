import 'package:common/model/transaction_detail_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class InvoiceState extends Equatable {
  final CubitState? status;
  final String message;
  final List<TransactionModel> transaction;

  const InvoiceState({
    this.status = CubitState.initial,
    this.message = '',
    this.transaction = const [],
  });

  InvoiceState copyWith({
    CubitState? status,
    String? message,
    List<TransactionModel>? transaction,
  }) {
    return InvoiceState(
      status: status ?? this.status,
      message: message ?? this.message,
      transaction: transaction ?? this.transaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        transaction,
      ];
}
