import 'dart:io';

import 'package:common/model/categories_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

import '../../data/model/stock_model.dart';

class StockState extends Equatable {
  final CubitState status;
  final String message;
  final String selectedCategoryId;
  final String searchedProduct;
  final CategoryModel? selectedCategory;
  final List<StockModel> stockList;
  final File? image;
  final List<CategoryModel> categories;

  const StockState({
    this.status = CubitState.initial,
    this.message = '',
    this.selectedCategoryId = '0',
    this.searchedProduct = '',
    this.selectedCategory,
    this.stockList = const [],
    this.categories = const [],
    this.image,
  });

  StockState copyWith({
    CubitState? status,
    String? message,
    String? selectedCategoryId,
    String? searchedProduct,
    final CategoryModel? selectedCategory,
    List<StockModel>? stockList,
    List<CategoryModel>? categories,
    File? image,
  }) {
    return StockState(
      status: status ?? this.status,
      message: message ?? this.message,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchedProduct: searchedProduct ?? this.searchedProduct,
      stockList: stockList ?? this.stockList,
      image: image ?? this.image,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedCategory,
        stockList,
        categories,
        searchedProduct,
        selectedCategoryId,
        message,
        image
      ];
}
