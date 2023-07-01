import 'dart:convert';
import 'dart:developer';

import 'package:common/model/categories_model.dart';
import 'package:common/utils/catch_error_logger.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/supabase/supabase.dart';
import 'package:product_list/data/model/product_list_model.dart';
import 'package:product_list/presentation/cubit/product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit()
      : super(const ProductListState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  void init() {
    fetchProductList().then((value) => fetchCategories());
  }

  Future<void> fetchProductList() async {
    try {
      List<dynamic> response;
      // if searched product name is not empty and category id is not 0
      // it will search product by name and category id
      if (state.searchedProduct.isNotEmpty && state.selectedCategoryId != '0') {
        log('1 query => ${state.searchedProduct} id => ${state.selectedCategoryId}');
        response = await _supabase
            .from('product')
            .select('*')
            .like('name', '%${state.searchedProduct}%')
            .eq('category_id', state.selectedCategoryId);
      }

      // if only searched product name not empty and category id is not 0,
      // it will search by product name only
      else if (state.searchedProduct.isNotEmpty &&
          state.selectedCategoryId == '0') {
        log('2 query => ${state.searchedProduct}');
        response = await _supabase.from('product').select('*').filter(
              'name',
              'like',
              '%${state.searchedProduct}%',
            );
      }

      // if selected category id is not empty and not 0,
      // it will search by product category only
      else if (state.selectedCategoryId.isNotEmpty &&
          state.selectedCategoryId != '0') {
        log('3 id => ${state.selectedCategoryId}');
        response = await _supabase.from('product').select('*').filter(
              'category_id',
              'eq',
              state.selectedCategoryId,
            );
      }

      // if searched product name and selected category id is empty,
      // it will search all product
      else {
        log('4');
        response = await _supabase.from('product').select('*');
      }
      final encoded = jsonEncode(response);
      final List decoded = jsonDecode(encoded);
      final productList =
          decoded.map((e) => ProductListModel.fromJson(e)).toList();

      log(encoded);
      emit(state.copyWith(productList: productList));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
    }
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(status: CubitState.loading));
    try {
      final response = await _supabase.from('category').select('*');
      final encoded = jsonEncode(response);
      final List decoded = jsonDecode(encoded);
      final categories = decoded.map((e) => CategoryModel.fromJson(e)).toList();
      categories.insert(
          0, CategoryModel(id: 0, name: 'All', createdAt: DateTime.now()));

      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.hasData, categories: categories));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
    }
  }

  void fetchByCategory({required int categoryId}) async {
    emit(state.copyWith(selectedCategoryId: categoryId.toString()));
    fetchProductList();
    // log('$categoryId');
    // if (categoryId == 0) {
    //   fetchProductList();
    // } else {
    //   try {
    //     final response = await _supabase
    //         .from('product')
    //         .select('*')
    //         .filter('category_id', 'eq', '$categoryId');
    //     final encoded = jsonEncode(response);
    //     final List decoded = jsonDecode(encoded);
    //     log(encoded);
    //     final productList =
    //         decoded.map((e) => ProductListModel.fromJson(e)).toList();

    //     emit(state.copyWith(
    //         status: CubitState.hasData, productList: productList));
    //   } catch (e, stacktrace) {
    //     catchErrorLogger(e, stacktrace);
    //   }
    // }
  }

  void fetchByName({required String name}) async {
    emit(state.copyWith(searchedProduct: name));
    fetchProductList();
    // log(name);
    // if (name.isEmpty) {
    //   return;
    // } else {
    //   try {
    //     /// Search data conatined [name] value
    //     final response = await _supabase.from('product').select('*').filter(
    //           'name',
    //           'like',
    //           '%$name%',
    //         );
    //     final encoded = jsonEncode(response);
    //     final List decoded = jsonDecode(encoded);
    //     log(encoded);
    //     final productList =
    //         decoded.map((e) => ProductListModel.fromJson(e)).toList();

    //     // If Search resut is empty it will emitting no data state
    //     if (productList.isEmpty) {
    //       emit(state.copyWith(status: CubitState.noData));
    //       return;
    //     }

    //     emit(state.copyWith(
    //         status: CubitState.hasData, productList: productList));
    //   } catch (e, stacktrace) {
    //     catchErrorLogger(e, stacktrace);
    //   }
    // }
  }

  void setSearchedProduct({required String searchedProduct}) {
    emit(state.copyWith(searchedProduct: searchedProduct));
  }
}
