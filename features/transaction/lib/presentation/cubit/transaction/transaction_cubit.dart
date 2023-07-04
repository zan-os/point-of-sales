import 'dart:convert';
import 'dart:developer';

import 'package:common/utils/catch_error_logger.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/supabase/supabase.dart';
import 'package:common/model/transaction_detail_model.dart';

import '../transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit()
      : super(const TransactionState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  bool checkPayment(int totalBill, int receivedPayment) {
    if (totalBill > receivedPayment) {
      emit(state.copyWith(
          status: CubitState.error, message: 'Uang tidak cukup'));

      emit(state.copyWith(status: CubitState.initial));
      return false;
    } else {
      return true;
    }
  }

  void emitTransactionDetail(List<TransactionDetailModel> transactionDetail) {
    emit(state.copyWith(transactionDetail: transactionDetail));
  }

  void updateTransaction(
      {required int id,
      required int receivedPayment,
      required String phoneNumber,
      required String address,
      required int table,
      required int totalBill}) async {
    if (checkPayment(totalBill, receivedPayment)) {
      try {
        emit(state.copyWith(status: CubitState.loading));
        await _supabase.rpc('update_transaction', params: {
          'p_id': id,
          'p_received_payment_total': receivedPayment,
          'p_telephone': phoneNumber,
          'p_address': address,
          'p_table': table
        }).then((value) => deleteAllCart(transactionId: id));
        emit(state.copyWith(status: CubitState.success));
      } catch (e, stacktrace) {
        catchErrorLogger(e, stacktrace);
        emit(state.copyWith(status: CubitState.finishLoading));
      }
    }
  }

  void deleteAllCart({required int transactionId}) async {
    try {
      await _supabase
          .rpc('delete_all_cart_item')
          .then((value) => fetchTransaction(id: transactionId));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menghapus cart'));
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

          emit(state.copyWith(
              status: CubitState.hasData,
              transactionDetail: transactionDetail));
          log(encoded);
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

  void updateTransactionStatus({required int id}) async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      _supabase
          .from('transaction')
          .update({'transaction_status': 3})
          .eq('id', id)
          .then((value) {
            emit(state.copyWith(status: CubitState.success));
          });
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error,
          message: 'Gagal mengupdate status transaksi'));
    }
  }
}
