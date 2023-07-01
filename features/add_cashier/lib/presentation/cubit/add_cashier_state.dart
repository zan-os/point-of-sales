import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class AddCashierState extends Equatable {
  final CubitState status;
  final String userId;
  final String email;
  final String password;

  const AddCashierState({
    this.status = CubitState.initial,
    this.userId = '',
    this.email = '',
    this.password = '',
  });

  AddCashierState copyWith(
      {CubitState? status, String? userId, String? email, String? password}) {
    return AddCashierState(
        status: status ?? this.status,
        userId: userId ?? this.userId,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  @override
  List<Object> get props => [status, userId, email, password];
}
