import 'package:flutter/material.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class AddCashierScreen extends StatefulWidget {
  const AddCashierScreen({super.key});

  @override
  State<AddCashierScreen> createState() => _AddCashierScreenState();
}

class _AddCashierScreenState extends State<AddCashierScreen> {
  final unfocusNode = FocusNode();
  final nameController = TextEditingController();
  final roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const AppBarWidget(
            isHome: false, title: 'Tambah Pegawai', enableAction: false),
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
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Nama Pegawai',
              controller: nameController,
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Role Pegawai',
              controller: roleController,
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
      title: 'Tambah Pegawai',
      onTap: () {},
    );
  }
}
