import 'package:common/model/categories_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:product_list/data/model/product_list_model.dart';

class ProductListState extends Equatable {
  final CubitState status;
  final String selectedCategoryId;
  final String searchedProduct;
  final List<ProductListModel> productList;
  final List<CategoryModel> categories;

  const ProductListState({
    this.status = CubitState.initial,
    this.selectedCategoryId = '0',
    this.searchedProduct = '',
    this.productList = const [],
    this.categories = const [],
  });

  ProductListState copyWith(
      {CubitState? status,
      String? selectedCategoryId,
      String? searchedProduct,
      List<ProductListModel>? productList,
      List<CategoryModel>? categories}) {
    return ProductListState(
      status: status ?? this.status,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchedProduct: searchedProduct ?? this.searchedProduct,
      productList: productList ?? this.productList,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        status,
        productList,
        categories,
        searchedProduct,
        selectedCategoryId,
      ];
}
