import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';

import '../transaction_state.dart';

class TransactionDetailCubit extends Cubit<TransactionState> {
  TransactionDetailCubit()
      : super(const TransactionState(status: CubitState.initial));
}
