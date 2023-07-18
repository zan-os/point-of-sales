import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:common/model/categories_model.dart';
import 'package:common/utils/catch_error_logger.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/image_manager/image_manager.dart';
import 'package:dependencies/supabase/supabase.dart';
import 'package:path/path.dart';
import 'package:stock/presentation/cubit/stock_state.dart';

import '../../data/model/stock_model.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit() : super(const StockState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  void init() {
    fetchProductList();
  }

  Future<void> fetchProductList() async {
    try {
      emit(state.copyWith(status: CubitState.loading));

      final response = await _supabase.rpc('fetch_stocks');

      final encoded = jsonEncode(response);
      final List decoded = jsonDecode(encoded);
      final productList = decoded.map((e) => StockModel.fromJson(e)).toList();

      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.initial, stockList: productList));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.error, message: 'Gagal mendapatkan data stok'));
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      final image = await ImagePicker().pickImage(source: source);
      emit(state.copyWith(status: CubitState.finishLoading));
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(sourcePath: img);
    } catch (e) {
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.error, message: e.toString()));
    }
  }

  Future<File?> cropImage({required File sourcePath}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
    );

    emit(state.copyWith(status: CubitState.finishLoading));

    if (croppedFile == null) return null;
    emit(state.copyWith(
        status: CubitState.hasData, image: File(croppedFile.path)));
    return File(croppedFile.path);
  }

  void fetchCategories() async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      final tes = await _supabase.from('category').select('*');
      final response = jsonEncode(tes);
      final List json = jsonDecode(response);
      final categories = json.map((e) => CategoryModel.fromJson(e)).toList();

      emit(state.copyWith(
          status: CubitState.finishLoading, categories: categories));
      emit(state.copyWith(status: CubitState.initial, categories: categories));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.error, message: e.toString()));
    }
  }

  void setSelectedCategory({required CategoryModel categoryModel}) {
    emit(state.copyWith(
        status: CubitState.initial, selectedCategory: categoryModel));
  }

  void updateProduct(
      {required int productId,
      required String name,
      required String price,
      required String image,
      String? categoryId,
      required String stock}) async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      if (state.image?.path != null) {
        final imagePath =
            'images/product/${basename(state.image?.path ?? image)}${math.Random().nextInt(10000)}';

        await _supabase.storage.from('pos').upload(
              imagePath,
              state.image ?? File(''),
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false),
            );

        await _supabase.from('product').update({
          'name': name,
          'price': price,
          'image':
              'https://qfcfviouxxtwfutjzbxw.supabase.co/storage/v1/object/public/pos/$imagePath',
          'category_id': state.selectedCategory?.id ?? 1
        }).match({'id': productId});
      } else {
        await _supabase.from('product').update({
          'name': name,
          'price': price,
          'category_id': state.selectedCategory?.id ?? 1
        }).match({'id': productId});
      }

      await _supabase
          .from('stock')
          .update({'qty': stock}).match({'product_id': productId});
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(
          status: CubitState.success, message: 'Produk berhasil diubah'));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.error, message: e.toString()));
    }
  }

  void deleteProduct({required int productId}) async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      await _supabase
          .from('stock')
          .delete()
          .match({'product_id': productId}).then(
        (value) async => await _supabase.from('product').delete().match(
          {'id': productId},
        ),
      );

      emit(state.copyWith(
          status: CubitState.success, message: 'Produk berhasil dihapus'));
      emit(state.copyWith(status: CubitState.finishLoading));
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
      emit(state.copyWith(status: CubitState.finishLoading));
      emit(state.copyWith(status: CubitState.error, message: e.toString()));
    }
  }
}
