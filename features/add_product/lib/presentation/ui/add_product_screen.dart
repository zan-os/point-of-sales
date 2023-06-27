import 'dart:developer';
import 'dart:io';

import 'package:dependencies/image_manager/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';
import 'package:ui/widgets/rounded_product_container.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  String name = '-';
  String price = '-';

  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(sourcePath: img);
      setState(() {
        _image = img;
      });
    } catch (e) {
      log('Pick Image Error ==> $e');
    }
  }

  Future<File?> _cropImage({required File sourcePath}) async {
    CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: sourcePath.path);
    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  void _showBottomSheet() {
    scaffoldKey.currentState?.showBottomSheet((context) {
      return Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedButtonWidget(
              title: 'Gallery',
              onTap: () => _pickImage(ImageSource.gallery),
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
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: const AppBarWidget(
            isHome: false, title: 'Tambah Produk', enableAction: false),
        backgroundColor: Colors.white,
        body: _buildBody(),
      ),
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Center(
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
                      name: name,
                      price: price,
                      path: _image,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: () => _showBottomSheet(),
              child: const Text(
                'Upload Foto',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Nama Produk',
              controller: nameController,
              onChange: (value) {
                setState(() {
                  name = value;
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
                  price = value;
                });
              },
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

  Widget _buildAddButton() {
    return RoundedButtonWidget(
      title: 'Tambah Produk',
      onTap: () {},
    );
  }
}
