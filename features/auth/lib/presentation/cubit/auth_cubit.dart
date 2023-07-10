import 'dart:developer';

import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:dependencies/supabase/supabase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthenticateState> {
  AuthCubit() : super(const AuthenticateState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  void loginWithEmail(String email, String password) async {
      emit(state.copyWith(status: CubitState.loading));

    try {
      final response = await _supabase.auth
          .signInWithPassword(email: email, password: password);

      final userId = response.user?.id;

      if (userId != null) {
        getRole(userId);
      }
    } on AuthException catch (e) {
      log('$e');
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.error, message: e.message));
    } catch (e) {
      log('$e');
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.error, message: 'Something went wrong'));
    }
  }

  void getRole(String userId) async {
      emit(state.copyWith(status: CubitState.loading));
    try {
      final response = await _supabase
          .from('role')
          .select('role_name')
          .eq('user_id', userId)
          .single();
      final role = response['role_name'];

      emit(state.copyWith(
          status: CubitState.hasData, userId: userId, role: role));
      emit(state.copyWith(status: CubitState.success));
    } catch (e) {
      log('$e');
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal mendapatkan role'));
    }
  }
}

class AuthModel extends Equatable {
  final String userId;
  final String role;

  const AuthModel({this.userId = '', this.role = ''});

  AuthModel copyWith({
    String? userId,
    String? role,
  }) {
    return AuthModel(
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [userId, role];
}
