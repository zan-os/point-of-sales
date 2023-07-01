import 'dart:developer';
import 'dart:io';

import 'package:add_product/presentation/cubit/add_product_cubit.dart';
import 'package:add_product/presentation/cubit/add_product_state.dart';
import 'package:common/model/categories_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/image_manager/image_manager.dart';
import 'package:dependencies/loading_animation/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/category_picker.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';
import 'package:ui/widgets/rounded_product_container.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode unfocusNode = FocusNode();
    return BlocProvider<AddProductCubit>(
      create: (context) => AddProductCubit(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
        child: const AddProductContent(),
      ),
    );
  }
}

class AddProductContent extends StatefulWidget {
  const AddProductContent({
    super.key,
  });

  @override
  State<AddProductContent> createState() => _AddProductContentState();
}

class _AddProductContentState extends State<AddProductContent> {
  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final stockController = TextEditingController();

  final categoryController = TextEditingController();

  String _name = '-';

  String _price = '0';

  File? _image;

  late AddProductCubit cubit;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => cubit.fetchCategories());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit = BlocProvider.of<AddProductCubit>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarWidget(
          isHome: false, title: 'Tambah Produk', enableAction: false),
      backgroundColor: Colors.white,
      body: BlocConsumer<AddProductCubit, AddProductState>(
        listener: (context, state) {
          log('state $state');
          if (state.status == CubitState.hasData) {
            log('set state');
            setState(() {
              _image = state.image;
            });
            Navigator.pop(context);
          }
          if (state.status == CubitState.loading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  LoadingAnimationWidget.inkDrop(color: Colors.white, size: 50),
            );
          }
        },
        builder: (context, state) {
          return _buildBody();
        },
      ),
    );
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedButtonWidget(
              title: 'Gallery',
              onTap: () {
                cubit.pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Text('Or'),
            const SizedBox(
              height: 8.0,
            ),
            RoundedButtonWidget(
              title: 'Camera',
              onTap: () {
                cubit.pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker({required List<CategoryModel> categories}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CategoryPicker(
        categories: categories,
        onSelectButtonTap: (category) {
          cubit.setSelectedCategory(categoryModel: category);
          categoryController.text = category.name ?? '';
        },
      ),
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          padding: MediaQuery.of(context).viewInsets,
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            _buildPreviewCard(),
            const SizedBox(
              height: 16.0,
            ),
            _buildUploadTextButton(),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Nama Produk',
              controller: nameController,
              onChange: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Harga Produk',
              controller: priceController,
              onChange: (value) {
                setState(() {
                  _price = value;
                });
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            BlocBuilder<AddProductCubit, AddProductState>(
              builder: (context, state) => GestureDetector(
                onTap: () {
                  _showCategoryPicker(categories: state.categories);
                },
                child: RoundBorderedTextFIeld(
                  enabled: false,
                  label: 'Kategori Produk',
                  controller: categoryController,
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Stok',
              controller: stockController,
              onChange: (value) {},
            ),
            const SizedBox(
              height: 16.0,
            ),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildUploadTextButton() {
    return GestureDetector(
      onTap: () => _showImageSourcePicker(),
      child: const SizedBox(
        height: 25,
        width: 100,
        child: Center(
          child: Text(
            'Upload Foto',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Center _buildPreviewCard() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Preview Product',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16.0,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: RoundedProductContainer(
              name: _name,
              price: _price,
              path: _image,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return RoundedButtonWidget(
      title: 'Tambah Produk',
      onTap: () => context.read<AddProductCubit>().uploadProduct(
            name: nameController.text.trim(),
            price: priceController.text.trim(),
            stock: stockController.text.trim(),
          ),
    );
  }
}
