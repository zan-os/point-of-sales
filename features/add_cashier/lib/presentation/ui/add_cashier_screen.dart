import 'package:add_cashier/presentation/cubit/add_cahsier_cubit.dart';
import 'package:add_cashier/presentation/cubit/add_cashier_state.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/loading_animation/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class AddCashierScreen extends StatelessWidget {
  const AddCashierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddCashierCubit>(
      create: (context) => AddCashierCubit(),
      child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child:const _AddCashierContent()),
    );
  }
}

class _AddCashierContent extends StatefulWidget {
  const _AddCashierContent();

  @override
  State<_AddCashierContent> createState() => _AddCashierContentState();
}

class _AddCashierContentState extends State<_AddCashierContent> {
  final unfocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AddCashierCubit cubit;

  SafeArea _scaffoldBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<AddCashierCubit, AddCashierState>(
          listener: (context, state) {
            if (state.status == CubitState.loading) {
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

            if (state.status == CubitState.hasData) {
              const SnackBar(content: Text('Berhasil menambahka pegawai baru'));
            }
          },
          builder: (context, state) => Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 8.0,
              ),
              RoundBorderedTextFIeld(
                enabled: true,
                label: 'Email Pegawai',
                controller: emailController,
              ),
              const SizedBox(
                height: 16.0,
              ),
              RoundBorderedTextFIeld(
                enabled: true,
                label: 'Password',
                controller: passwordController,
              ),
              const SizedBox(
                height: 16.0,
              ),
              _addButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return RoundedButtonWidget(
      title: 'Tambah Pegawai',
      onTap: () {
        cubit.registerCashier(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit = context.read<AddCashierCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const AppBarWidget(
            isHome: false, title: 'Tambah Pegawai', enableAction: false),
        backgroundColor: Colors.white,
        body: _scaffoldBody(),
      ),
    );
  }
}
