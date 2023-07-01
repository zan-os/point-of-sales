import 'dart:io';

import 'package:common/model/categories_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/equatable/equatable.dart';

class AddProductState extends Equatable {
  final CubitState status;
  final String name;
  final String price;
  final CategoryModel? selectedCategory;
  final String stock;
  final File? image;
  final List<CategoryModel> categories;

  const AddProductState({
    this.status = CubitState.initial,
    this.name = '',
    this.price = '',
    this.selectedCategory,
    this.stock = '',
    this.categories = const [],
    this.image,
  });

  AddProductState copyWith(
      {CubitState? status,
      String? name,
      String? price,
      CategoryModel? selectedCategory,
      String? stock,
      File? image,
      List<CategoryModel>? categories}) {
    return AddProductState(
      status: status ?? this.status,
      name: name ?? this.name,
      price: price ?? this.price,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props =>
      [status, name, price, selectedCategory, stock, image, categories];
}
