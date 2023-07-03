import 'dart:developer';

import 'package:common/utils/cubit_state.dart';
import 'package:common/utils/currency_formatter.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transaction/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/helper/show_snackbar.dart';
import 'package:ui/widgets/product_list_tile.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

import '../../../data/model/transaction_detail/transaction_detail_model.dart';
import '../../cubit/transaction_state.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transaction = ModalRoute.of(context)?.settings.arguments
        as List<TransactionDetailModel>;
    return BlocProvider<TransactionCubit>(
      create: (context) =>
          TransactionCubit()..emitTransactionDetail(transaction),
      child: const _TransactionDetailContent(),
    );
  }
}

class _TransactionDetailContent extends StatelessWidget {
  const _TransactionDetailContent();

  @override
  Widget build(BuildContext context) {
    final FocusNode unfocusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => Focus.of(context).requestFocus(unfocusNode),
        child: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {
            if (state.status == CubitState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                showSnackBar(state.message, isError: true),
              );
            }
            if (state.status == CubitState.success) {
              log('berhasil');
              ScaffoldMessenger.of(context).showSnackBar(
                showSnackBar('Transaksi Selesai', isError: false),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return _scaffoldBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _scaffoldBody(BuildContext context, TransactionState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          shrinkWrap: true,
          padding: MediaQuery.of(context).viewInsets,
          children: [
            _header(state.transactionDetail.first.transaction),
            _transactionDetail(state),
            _doneButton(context, state.transactionDetail.first.transactionId)
          ],
        ),
      ),
    );
  }

  Widget _header(Transaction transaction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          color: CupertinoColors.systemGreen,
          size: 60,
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Transaksi Berhasil',
          style: TextStyle(
              fontSize: 18,
              color: CupertinoColors.systemGreen,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 16.0),
        Text(
          formatRupiah(transaction.paymentTotal),
          style: const TextStyle(
              fontSize: 24,
              color: ColorConstants.blackColor,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  Widget _transactionDetail(TransactionState state) {
    final transaction = state.transactionDetail.first.transaction;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Ordered Product Section
          const Text(
            'List Pesanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorConstants.blackColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: ColorConstants.greyColor),
          ),
          _buildOrderedItem(state),

          // Payment Detail Section
          const Text(
            'Detail Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorConstants.blackColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: ColorConstants.greyColor),
          ),
          _transactionTile(
              isBold: false,
              title: 'Meja',
              content: transaction.table.toString(),
              isCurrency: false),
          _transactionTile(
              isBold: false,
              title: 'No. Telepon',
              content: transaction.telephone.toString(),
              isCurrency: false),
          _transactionTile(
              isBold: false,
              title: 'Alamat',
              content: transaction.address.toString(),
              isCurrency: false),
          _transactionTile(
              isBold: false,
              title: 'Total Pembayaran',
              price: transaction.receivedPaymentTotal,
              isCurrency: true),
          _transactionTile(
              isBold: false,
              title: 'Total Tagihan',
              price: transaction.paymentTotal,
              isCurrency: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: ColorConstants.greyColor),
          ),
          _transactionTile(
              isBold: true,
              title: 'Kembalian',
              price:
                  transaction.receivedPaymentTotal - transaction.paymentTotal,
              isCurrency: true),
        ],
      ),
    );
  }

  Padding _doneButton(BuildContext context, int transactionId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RoundedButtonWidget(
          title: 'Selesai',
          onTap: () {
            context
                .read<TransactionCubit>()
                .updateTransactionStatus(id: transactionId);
          }),
    );
  }

  Widget _transactionTile(
      {required String title,
      String? content,
      int? price,
      required bool isCurrency,
      required bool isBold}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: ColorConstants.blackColor,
            ),
          ),
          Text(
            isCurrency ? formatRupiah(price ?? 0) : content ?? '',
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: ColorConstants.blackColor,
            ),
          )
        ],
      ),
    );
  }

  ListView _buildOrderedItem(TransactionState state) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: state.transactionDetail.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final transaction = state.transactionDetail[index];

        return ProductListTile(
          image: transaction.product.image,
          productName: transaction.product.name,
          productPrice: transaction.price,
          productQty: transaction.qty.toString(),
        );
      },
    );
  }
}
