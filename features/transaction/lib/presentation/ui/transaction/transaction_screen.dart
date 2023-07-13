import 'package:common/navigation/app_router.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:common/utils/currency_formatter.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/loading_animation/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:transaction/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:transaction/presentation/cubit/transaction_state.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/helper/show_snackbar.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionCubit>(
      create: (context) => TransactionCubit(),
      child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const _TransactionScreenContent()),
    );
  }
}

class _TransactionScreenContent extends StatefulWidget {
  const _TransactionScreenContent();

  @override
  State<_TransactionScreenContent> createState() =>
      _TransactionScreenContentState();
}

class _TransactionScreenContentState extends State<_TransactionScreenContent> {
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _tableController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late TransactionCubit cubit;
  late Map<String, dynamic> args;

  @override
  void didChangeDependencies() {
    cubit = context.read<TransactionCubit>();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _phoneNumberController.dispose();
    _tableController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarWidget(
          isHome: false, title: 'Transaksi', enableAction: false),
      backgroundColor: Colors.white,
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state.status == CubitState.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              showSnackBar('Berhasil', isError: false),
            );
          }
          if (state.status == CubitState.hasData) {
            Navigator.popAndPushNamed(
              context,
              AppRouter.transactionDetail,
              arguments: state.transactionDetail,
            ).then((value) => Navigator.pop(context));
          }
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
          if (state.status == CubitState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              showSnackBar(state.message, isError: true),
            );
          }
        },
        builder: (context, state) {
          return _scaffoldBody();
        },
      ),
    );
  }

  Widget _scaffoldBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          padding: MediaQuery.of(context).viewInsets,
          shrinkWrap: true,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.blackColor,
                  ),
                ),
                Text(
                  formatRupiah(args['total_bill'] ?? 0),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.blackColor,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Divider(color: ColorConstants.greyColor),
            const SizedBox(
              height: 8.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Nominal Uang',
              controller: _paymentController,
              keyboardType: TextInputType.number,
              onChange: (value) {},
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Meja',
              keyboardType: TextInputType.number,
              controller: _tableController,
              onChange: (value) {},
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Nomor Handphone',
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              controller: _phoneNumberController,
              onChange: (value) {},
            ),
            const SizedBox(
              height: 16.0,
            ),
            RoundBorderedTextFIeld(
              enabled: true,
              label: 'Alamat',
              keyboardType: TextInputType.text,
              controller: _addressController,
              onChange: (value) {},
            ),
            const SizedBox(
              height: 16.0,
            ),
            _payButton(),
          ],
        ),
      ),
    );
  }

  Widget _payButton() {
    final address = _addressController.text.trim();
    final payment = _paymentController.text.trim();
    final table = _tableController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    return RoundedButtonWidget(
      title: 'Bayar',
      onTap: () => (_formValidator())
          ? cubit.updateTransaction(
              totalBill: args['total_bill'],
              id: args['transaction_id'] ?? '0',
              receivedPayment: payment,
              phoneNumber: phoneNumber,
              address: address,
              table: table,
            )
          : null,
    );
  }

  bool _formValidator() {
    final payment = _paymentController.text.trim();

    if (payment.isNotEmpty) {
      return true;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(showSnackBar('Masukan nominal uang', isError: true));
    return false;
  }
}
