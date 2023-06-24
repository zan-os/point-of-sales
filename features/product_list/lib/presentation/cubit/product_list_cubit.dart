import 'package:common/common.dart';

import 'model/product_list_model.dart';

class ProductListCubit extends Cubit<CubitState> {
  ProductListCubit() : super(LoadingState());

  void setSelectedCategory(int? index) {
    emit(CompleteState(ProductListModel(categoryIndex: index)));
  }
}
