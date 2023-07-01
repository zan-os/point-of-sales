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
    log('email : $email password: $password');

    try {
      emit(state.copyWith(status: CubitState.loading));
      final response = await _supabase.auth
          .signInWithPassword(email: email, password: password);

      final userId = response.user?.id;

      if (userId != null) {
        getRole(userId);
        log('user id = $userId');
      }
    } catch (e) {
      log('$e');
    }
  }

  void getRole(String userId) async {
    try {
      final response = await _supabase
          .from('role')
          .select('role_name')
          .eq('user_id', userId)
          .single();
      final role = response['role_name'];

      emit(state.copyWith(
          status: CubitState.hasData, userId: userId, role: role));
      log('getrole state ==> ${state.status}');
    } catch (e) {
      log('$e');
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
