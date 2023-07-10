import 'package:common/model/categories_model.dart';
import 'package:common/model/product_model.dart';
import 'package:common/model/stock_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class ProductListState extends Equatable {
  final CubitState status;
  final String message;
  final String selectedCategoryId;
  final String searchedProduct;
  final StockModel stock;
  final List<ProductModel> productList;
  final List<CategoryModel> categories;

  const ProductListState({
    this.status = CubitState.initial,
    this.message = '',
    this.selectedCategoryId = '0',
    this.searchedProduct = '',
    this.stock = const StockModel(),
    this.productList = const [],
    this.categories = const [],
  });

  ProductListState copyWith(
      {CubitState? status,
      String? message,
      String? selectedCategoryId,
      String? searchedProduct,
      StockModel? stock,
      List<ProductModel>? productList,
      List<CategoryModel>? categories}) {
    return ProductListState(
      status: status ?? this.status,
      message: message ?? this.message,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchedProduct: searchedProduct ?? this.searchedProduct,
      stock: stock ?? this.stock,
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
        message,
        stock,
      ];
}
