import 'dart:io';
import 'package:common/model/categories_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/image_manager/image_manager.dart';
import 'package:dependencies/loading_animation/loading_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock/presentation/cubit/stock_cubit.dart';
import 'package:stock/presentation/cubit/stock_state.dart';
import 'package:ui/helper/show_snackbar.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/category_picker.dart';
import 'package:ui/widgets/delete_button_widget.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';
import 'package:ui/widgets/rounded_product_container.dart';

import '../../../data/model/stock_model.dart';

class ManageStockScreen extends StatelessWidget {
  const ManageStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode unfocusNode = FocusNode();
    final stock = ModalRoute.of(context)?.settings.arguments as StockModel;
    return BlocProvider<StockCubit>(
      create: (context) => StockCubit(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
        child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: _ManageStockContent(stock)),
      ),
    );
  }
}

class _ManageStockContent extends StatefulWidget {
  final StockModel stock;
  const _ManageStockContent(this.stock);

  @override
  State<_ManageStockContent> createState() => _ManageStockContentState();
}

class _ManageStockContentState extends State<_ManageStockContent> {
  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final stockController = TextEditingController();

  final categoryController = TextEditingController();

  static const invalidFormSnackbar = SnackBar(
    content: Text('Harap isi semua data'),
    backgroundColor: CupertinoColors.systemRed,
  );

  SnackBar _showSnackbar(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: CupertinoColors.systemGreen,
    );
  }

  String _name = '-';

  int _price = 0;

  File? _image;
  String? _imageUrl;

  late StockCubit cubit;
  late StockModel stock;

  void initData() {
    _name = stock.productName ?? '';
    _price = stock.productPrice ?? 0;
    _imageUrl = stock.productImage;
    nameController.text = stock.productName ?? '';
    priceController.text = stock.productPrice.toString();
    categoryController.text = stock.categoryName.toString();
    stockController.text = stock.stockQty.toString();
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

  SafeArea _scaffoldBody() {
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
            _previewCard(),
            const SizedBox(
              height: 16.0,
            ),
            _imagePickerText(),
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
              keyboardType: TextInputType.number,
              controller: priceController,
              onChange: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _price = int.parse(value);
                  });
                }
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            BlocBuilder<StockCubit, StockState>(
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
              keyboardType: TextInputType.number,
              controller: stockController,
              onChange: (value) {},
            ),
            const SizedBox(
              height: 16.0,
            ),
            _addButton(),
            const SizedBox(
              height: 16.0,
            ),
            _deleteButton()
          ],
        ),
      ),
    );
  }

  GestureDetector _imagePickerText() {
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

  Center _previewCard() {
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
              image: _imageUrl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addButton() {
    return RoundedButtonWidget(
        title: 'Edit Produk',
        onTap: () {
          (_formValidator())
              ? context.read<StockCubit>().updateProduct(
                  image: (_image != null) ? _imageUrl! : '',
                  name: nameController.text.trim(),
                  price: priceController.text.trim(),
                  productId: stock.productId!,
                  stock: stockController.text.trim())
              : ScaffoldMessenger.of(context).showSnackBar(invalidFormSnackbar);
        });
  }

  Widget _deleteButton() {
    return DeleteButtonWidget(
      title: 'Hapus Produk',
      onTap: () {
        if (stock.productId != null) {
          cubit.deleteProduct(productId: stock.productId!);
        }
      },
    );
  }

  bool _formValidator() {
    final name = nameController.text.trim();
    final price = priceController.text.trim();
    final stock = stockController.text.trim();
    if (name.isNotEmpty && price.isNotEmpty && stock.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => cubit.fetchCategories());
    stock = widget.stock;
    initData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit = BlocProvider.of<StockCubit>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode unfocusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarWidget(
          isHome: false, title: 'Edit Produk', enableAction: false),
      backgroundColor: Colors.white,
      body: BlocConsumer<StockCubit, StockState>(
        listener: (context, state) {
          if (state.status == CubitState.hasData) {
            setState(() {
              _image = state.image;
            });
          }
          if (state.status == CubitState.success) {
            ScaffoldMessenger.of(context)
                .showSnackBar(_showSnackbar(state.message));
            Navigator.pop(context);
          }
          if (state.status == CubitState.loading) {
            FocusScope.of(context).requestFocus(unfocusNode);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.white,
                  size: 50,
                ),
              ),
            );
          }
          if (state.status == CubitState.finishLoading) {
            Navigator.pop(context);
          }
          if (state.status == CubitState.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(showSnackBar(state.message, isError: true));
          }
        },
        builder: (context, state) {
          return _scaffoldBody();
        },
      ),
    );
  }
}
