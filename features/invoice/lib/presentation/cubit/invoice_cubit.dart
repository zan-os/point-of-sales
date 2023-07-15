import 'dart:convert';

import 'package:common/model/transaction_detail_model.dart';
import 'package:common/utils/catch_error_logger.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/supabase/supabase.dart';
import 'package:invoice/presentation/cubit/invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(const InvoiceState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  void fetchTransactionHistory() async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      await _supabase
          .from('transaction')
          .select()
          .filter('transaction_status', 'eq', '3')
          .then(
        (response) {
          final encoded = jsonEncode(response);
          final List decoded = jsonDecode(encoded);
          final transactionDetail =
              decoded.map((e) => TransactionModel.fromJson(e)).toList();

          if (decoded.isNotEmpty) {
            emit(state.copyWith(
              status: CubitState.hasData,
              transaction: transactionDetail,
            ));
            emit(state.copyWith(status: CubitState.finishLoading));
            emit(state.copyWith(status: CubitState.initial));
          } else {
            emit(state.copyWith(status: CubitState.finishLoading));
            emit(state.copyWith(status: CubitState.noData));
          }
        },
      );
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.error,
          message: 'Gagal gagal mendapatkan data transaksi'));
    }
  }

  void fetchTransaction({required int id}) async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      await _supabase
          .from('transaction_detail')
          .select(
              '*, transaction:transaction_id (*), product:product_id (name, image)')
          .filter('transaction_id', 'eq', id)
          .then(
        (response) {
          final encoded = jsonEncode(response);
          final List decoded = jsonDecode(encoded);
          final transactionDetail =
              decoded.map((e) => TransactionDetailModel.fromJson(e)).toList();

          emit(state.copyWith(status: CubitState.finishLoading));
          emit(state.copyWith(
              status: CubitState.success,
              transactionDetail: transactionDetail));
          emit(state.copyWith(status: CubitState.initial));
        },
      );
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.error,
          message: 'Gagal gagal mendapatkan data transaksi'));
    }
  }
}
