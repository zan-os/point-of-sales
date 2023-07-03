import 'dart:convert';
import 'dart:developer';

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
    product:product_id (*)''').then(
              (response) {
        final encoded = jsonEncode(response);
        final List decoded = jsonDecode(encoded);
        final cartDetail = decoded.map((e) => CartModel.fromJson(e)).toList();

        emit(state.copyWith(cartDetail: cartDetail));

        if (cartDetail.isNotEmpty) {
          getTotalBill();
        }
      });
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal mendapatkan kategori'));
    }
  }

  void getTotalBill() async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      final totalBill = await _supabase.rpc('get_total_bill').select();
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.hasData, totalBill: int.parse(totalBill)));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
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
        'p_received_payment_total': 200000,
        'p_telephone': 0821122651231,
        'p_address': 'Gurame street',
        'p_user_id': userId,
        'p_table': 8
      }).then((value) async {
        log('tra id $value');
        await _supabase.rpc(
          'add_transaction_detail',
          params: {'p_transaction_id': value},
        );

        emit(state.copyWith(status: CubitState.finishLoading));
        emit(state.copyWith(status: CubitState.initial));
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
