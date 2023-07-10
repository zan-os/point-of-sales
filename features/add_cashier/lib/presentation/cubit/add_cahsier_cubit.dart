import 'dart:developer';

import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/supabase/supabase.dart';

import 'add_cashier_state.dart';

class AddCashierCubit extends Cubit<AddCashierState> {
  AddCashierCubit() : super(const AddCashierState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  void registerCashier(
      {required String email, required String password}) async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      final response =
          await _supabase.auth.signUp(email: email, password: password);
      final userId = response.user?.id;
      await _supabase
          .from('role')
          .insert({'user_id': userId, 'role_name': 'CASHIER'});
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.hasData));
    } catch (e) {
      log(e.toString());
    }
  }
}
