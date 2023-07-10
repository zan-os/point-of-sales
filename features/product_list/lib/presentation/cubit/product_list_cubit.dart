import 'dart:convert';
import 'dart:developer';

import 'package:common/model/categories_model.dart';
import 'package:common/model/product_model.dart';
import 'package:common/model/stock_model.dart';
import 'package:common/utils/catch_error_logger.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/supabase/supabase.dart';
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
        response = await _supabase.from('product').select('*').filter(
              'category_id',
              'eq',
              state.selectedCategoryId,
            );
      }

      // if searched product name and selected category id is empty,
      // it will search all product
      else {
        response = await _supabase.from('product').select('*');
      }
      final encoded = jsonEncode(response);
      final List decoded = jsonDecode(encoded);
      final productList = decoded.map((e) => ProductModel.fromJson(e)).toList();

      log(encoded);
      emit(state.copyWith(productList: productList));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menambahkan ke keranjang'));
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

      emit(state.copyWith(
          status: CubitState.finishLoading, categories: categories));
      emit(state.copyWith(status: CubitState.initial));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menambahkan ke keranjang'));
    }
  }

  void fetchByCategory({required int categoryId}) async {
    emit(state.copyWith(selectedCategoryId: categoryId.toString()));
    fetchProductList();
  }

  void fetchByName({required String name}) async {
    emit(state.copyWith(searchedProduct: name));
    fetchProductList();
  }

  void setSearchedProduct({required String searchedProduct}) {
    emit(state.copyWith(searchedProduct: searchedProduct));
  }

  void addToCart({required ProductModel product}) async {
    try {
      final response = await _supabase
          .from('stock')
          .select('*, product:product_id (*)')
          .match({'product_id': product.id}).single();

      final encoded = jsonEncode(response);
      final decoded = jsonDecode(encoded);
      final stock = StockModel.fromJson(decoded);

      if (stock.qty == 0) {
        emit(state.copyWith(status: CubitState.error, message: 'Stock kosong'));
      } else {
        await _supabase.rpc(
          'add_to_cart',
          params: {
            'p_product_id': product.id,
            'p_product_price': product.price
          },
        );
        emit(state.copyWith(
            status: CubitState.success,
            message: 'Berhasil menambahkan ke keranjang'));

        emit(state.copyWith(status: CubitState.initial));
      }
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal menambahkan ke keranjang'));
    }
  }

  Future<void> fetchProductDetail({required int productId}) async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      final response = await _supabase
          .from('stock')
          .select('*, product:product_id (*)')
          .match({'product_id': productId}).single();

      final encoded = jsonEncode(response);
      final decoded = jsonDecode(encoded);
      final stock = StockModel.fromJson(decoded);

      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.hasData, stock: stock));
      log(encoded);
      emit(state.copyWith(status: CubitState.initial));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal mendapatkan produk'));
    }
  }
}
