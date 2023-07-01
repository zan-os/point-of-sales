import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class AuthenticateState extends Equatable {
  final CubitState status;
  final String role;
  final String userId;

  const AuthenticateState({
    required this.status,
    this.role = '',
    this.userId = '',
  });

  AuthenticateState copyWith({
    CubitState? status,
    String? role,
    String? userId,
  }) {
    return AuthenticateState(
      status: status ?? this.status,
      role: role ?? this.role,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [status, role, userId];
}
