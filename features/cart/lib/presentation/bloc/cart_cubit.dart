import 'dart:convert';

import 'package:cart/presentation/bloc/cart_state.dart';
import 'package:common/model/product_model.dart';
import 'package:common/utils/catch_error_logger.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/supabase/supabase.dart';

import '../../data/cart_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  void init() {
    emit(state.copyWith(status: CubitState.loading));
    fetchCart();
    emit(state.copyWith(status: CubitState.finishLoading));
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
        } else if (cartDetail.isEmpty) {
          emit(state.copyWith(status: CubitState.finishLoading));
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
      emit(state.copyWith(status: CubitState.hasData));
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

  void addItemCart({required ProductModel product}) async {
    try {
      await _supabase.rpc(
        'add_to_cart',
        params: {'p_product_id': product.id, 'p_product_price': product.price},
      ).then(
        (value) {
          emit(
            state.copyWith(
              status: CubitState.hasData,
              message: 'Berhasil menambahkan barang',
            ),
          );

          init();
        },
      );

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menambahkan ke keranjang'));
    }
  }

  void removeItemCart({required ProductModel product}) async {
    try {
      await _supabase.rpc(
        'remove_one_item_cart',
        params: {'p_product_id': product.id, 'p_product_price': product.price},
      ).then(
        (value) {
          emit(
            state.copyWith(
              status: CubitState.hasData,
              message: 'Berhasil menambahkan barang',
            ),
          );

          fetchCart();
        },
      );

      emit(state.copyWith(status: CubitState.initial));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menambahkan ke keranjang'));
    }
  }

  void deleteItem({required int id}) {
    _supabase
        .from('cart')
        .delete()
        .match({'id': id}).then((value) => fetchCart());
  }
}
