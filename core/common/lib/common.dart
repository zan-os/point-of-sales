library common;

export 'cubit/cubit_state.dart';
export 'utils/state_handler.dart';
export 'package:equatable/equatable.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
