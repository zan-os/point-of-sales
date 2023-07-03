import 'dart:convert';

import 'package:cart/presentation/bloc/cart_state.dart';
import 'package:common/utils/catch_error_logger.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/supabase/supabase.dart';

import '../../data/cart_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  void init() {
    fetchCart();
  }

  void fetchCart() async {
    try {
      await _supabase
          .from('cart')
          .select('''id, cart_qty, product_price, total_price,
    product:product_id (*)''').then((response) {
        final encoded = jsonEncode(response);
        final List decoded = jsonDecode(encoded);
        final cartDetail = decoded.map((e) => CartModel.fromJson(e)).toList();

        emit(
            state.copyWith(status: CubitState.initial, cartDetail: cartDetail));

        if (cartDetail.isNotEmpty) {
          getTotalBill();
        }
      });
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal mendapatkan kategori'));
    }
  }

  void getTotalBill() async {
    try {
      final totalBill = await _supabase.rpc('get_total_bill').select();
      emit(state.copyWith(
          status: CubitState.initial, totalBill: int.parse(totalBill)));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal mendapatkan total bill'));
    }
  }

  void createOrder() async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      final userId = _supabase.auth.currentUser?.id;
      await _supabase.rpc('add_transaction', params: {
        'p_transaction_status': 1,
        'p_user_id': userId,
      }).then((createdTransactionId) async {
        await _supabase.rpc(
          'add_transaction_detail',
          params: {'p_transaction_id': createdTransactionId},
        );

        emit(state.copyWith(
            status: CubitState.finishLoading,
            createdTransactionId: createdTransactionId));
        emit(state.copyWith(
            status: CubitState.success,
            createdTransactionId: createdTransactionId));
        emit(state.copyWith(
            status: CubitState.initial,
            cartDetail: List.empty(),
            totalBill: 0));
      });
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal membuat transaksi'));
    }
  }

  void deleteAllCart() async {
    try {
      await _supabase.rpc('delete_all_cart_item');
      emit(state.copyWith(
          status: CubitState.success,
          message: 'Cart dihapus',
          cartDetail: List.empty(),
          totalBill: 0));
      emit(state.copyWith(status: CubitState.initial));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menghapus cart'));
    }
  }
}
