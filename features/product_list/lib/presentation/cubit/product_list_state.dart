import 'package:common/model/categories_model.dart';
import 'package:common/model/product_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class ProductListState extends Equatable {
  final CubitState status;
  final String selectedCategoryId;
  final String searchedProduct;
  final List<ProductModel> productList;
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
      List<ProductModel>? productList,
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
