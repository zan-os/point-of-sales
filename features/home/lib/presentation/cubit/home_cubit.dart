import 'dart:convert';
import 'dart:developer';

import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/supabase/supabase.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  void init() {
    getTotalProduct();
    getOutOfStockProduct();
    getTotalTransaction();
    getTotalIncome();
  }

  void getTotalProduct() async {
    final response = await _supabase.from('product').select();
    final encoded = jsonEncode(response);
    final List decoded = jsonDecode(encoded);
    log('produk = ${decoded.length}');
    emit(state.copyWith(totalProduct: decoded.length));
  }

  void getOutOfStockProduct() async {
    final response =
        await _supabase.from('stock').select().filter('qty', 'eq', 0);
    final encoded = jsonEncode(response);
    final List decoded = jsonDecode(encoded);
    log('out of stock = ${decoded.length}');
    emit(state.copyWith(outOfStockProduct: decoded.length));
  }

  void getTotalTransaction() async {
    final response = await _supabase
        .from('transaction')
        .select()
        .filter('transaction_status', 'eq', 3);
    final encoded = jsonEncode(response);
    final List decoded = jsonDecode(encoded);
    log('total transaction = ${decoded.length}');
    emit(state.copyWith(totalOrder: decoded.length));
  }

  void getTotalIncome() async {
    await _supabase.rpc('sum_payment_total').then((value) {
      emit(state.copyWith(totalIncome: value));
      log('total income = $value');
    });
  }
}
