import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class AuthenticateState extends Equatable {
  final CubitState status;
  final String role;
  final String userId;
  final String message;

  const AuthenticateState({
    required this.status,
    this.role = '',
    this.userId = '',
    this.message = '',
  });

  AuthenticateState copyWith({
    CubitState? status,
    String? message,
    String? role,
    String? userId,
  }) {
    return AuthenticateState(
      status: status ?? this.status,
      message: message ?? this.message,
      role: role ?? this.role,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [status, role, userId, message];
}
