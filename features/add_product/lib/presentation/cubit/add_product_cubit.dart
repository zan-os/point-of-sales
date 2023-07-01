import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:add_product/presentation/cubit/add_product_state.dart';
import 'package:common/model/categories_model.dart';
import 'package:common/utils/catch_error_logger.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/image_manager/image_manager.dart';
import 'package:dependencies/supabase/supabase.dart';
import 'package:path/path.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(const AddProductState(status: CubitState.initial));

  final _supabase = Supabase.instance.client;

  Future pickImage(ImageSource source) async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(sourcePath: img);
      log('image ==> ${state.image} state ==> ${state.status}');
    } catch (e) {
      log('Pick Image Error ==> $e');
    }
  }

  Future<File?> cropImage({required File sourcePath}) async {
    CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: sourcePath.path);

    emit(state.copyWith(
        status: CubitState.hasData, image: File(croppedFile?.path ?? '')));
    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  void fetchCategories() async {
    try {
      emit(state.copyWith(status: CubitState.loading));
      final tes = await _supabase.from('category').select('*');
      final response = jsonEncode(tes);
      final List json = jsonDecode(response);
      final categories = json.map((e) => CategoryModel.fromJson(e)).toList();

      emit(state.copyWith(status: CubitState.hasData, categories: categories));
      log(response);
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
    }
  }

  void setSelectedCategory({required CategoryModel categoryModel}) {
    emit(state.copyWith(selectedCategory: categoryModel));
    log('${state.selectedCategory}');
  }

  void uploadProduct({
    required String name,
    required String price,
    required String stock,
  }) async {
    try {
      final imagePath =
          'images/product/${basename(state.image?.path ?? '')}${math.Random().nextInt(10000)}';

      emit(state.copyWith(status: CubitState.loading));

      await _supabase.storage.from('pos').upload(
            imagePath,
            state.image ?? File(''),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      await _supabase.from('product').insert({
        'name': name,
        'price': price,
        'qty': stock,
        'category_id': state.selectedCategory?.id ?? 1,
        'image':
            'https://qfcfviouxxtwfutjzbxw.supabase.co/storage/v1/object/public/pos/$imagePath'
      });

      emit(state.copyWith(status: CubitState.hasData));
      log('image ==> $imagePath');
    } catch (e, stacktrace) {
      catchErrorLogger(e, stacktrace);
    }
  }
}
