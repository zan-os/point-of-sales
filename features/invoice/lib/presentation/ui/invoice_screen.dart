import 'package:common/model/transaction_detail_model.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:common/utils/currency_formatter.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice/presentation/cubit/invoice_cubit.dart';
import 'package:invoice/presentation/cubit/invoice_state.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/helper/show_snackbar.dart';
import 'package:ui/widgets/app_bar_widget.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceCubit>(
      create: (context) => InvoiceCubit(),
      child: const InvoiceScreenContent(),
    );
  }
}

class InvoiceScreenContent extends StatefulWidget {
  const InvoiceScreenContent({super.key});

  @override
  State<InvoiceScreenContent> createState() => _InvoiceScreenContentState();
}

class _InvoiceScreenContentState extends State<InvoiceScreenContent> {
  final unfocusNode = FocusNode();

  late InvoiceCubit cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cubit = context.read<InvoiceCubit>();

      cubit.fetchTransactionHistory();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        isHome: false,
        title: 'Transaction History',
        enableLeading: false,
      ),
      body: BlocConsumer<InvoiceCubit, InvoiceState>(
        listener: (context, state) {
          if (state.status == CubitState.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              showSnackBar('Berhasil', isError: false),
            );
          }
          // if (state.status == CubitState.hasData) {
          //   log('success harusnya pindah');
          //   Navigator.popAndPushNamed(
          //     context,
          //     AppRouter.transactionDetail,
          //     arguments: state.transaction,
          //   ).then((value) => Navigator.pop(context));
          // }
          if (state.status == CubitState.loading) {
            FocusScope.of(context).requestFocus(unfocusNode);
            // showDialog(
            //   context: context,
            //   barrierDismissible: false,
            //   builder: (context) =>
            //       LoadingAnimationWidget.inkDrop(color: Colors.white, size: 50),
            // );
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
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      children: [
        BlocBuilder<InvoiceCubit, InvoiceState>(
          builder: (context, state) {
            if (state.status == CubitState.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final transaction = state.transaction[index];
                  return _transactionListTile(transaction);
                },
                itemCount: state.transaction.length,
              );
            }
            return Container();
          },
        )
      ],
    );
  }

  Widget _transactionListTile(TransactionModel transaction) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConstants.whiteBackground),
      child: Column(
        children: [
          _invoiceCardHeader(transaction),
          _invoiceDivider(),
          _invoiceContent(
            title: 'Order Id',
            content: transaction.orderId,
          ),
          _invoiceContent(
            title: 'No. Telepon',
            content: transaction.telephone.toString(),
          ),
          _invoiceContent(
            title: 'No. Meja',
            content: transaction.table.toString(),
          ),
          _invoiceContent(
            title: 'Alamat',
            content: transaction.address,
          ),
          _invoiceContent(
            title: 'No. Telepon',
            content: transaction.telephone,
          ),
          _invoiceDivider(),
          _invoiceContent(
            title: 'Uang yang diterma',
            content: formatRupiah(transaction.receivedPaymentTotal),
          ),
          _invoiceContent(
            title: 'Total Tagihan',
            content: formatRupiah(transaction.paymentTotal),
          ),
          _invoiceContent(
            title: 'Kembalian',
            content: formatRupiah(
                transaction.receivedPaymentTotal - transaction.paymentTotal),
          ),
        ],
      ),
    );
  }

  Padding _invoiceDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: CupertinoColors.systemGrey4,
      ),
    );
  }

  Padding _invoiceContent({String? title, String? content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              content ?? '',
              overflow: TextOverflow.fade,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Row _invoiceCardHeader(TransactionModel transaction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _dateFormatter(date: transaction.createdAt),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          _orderStatus(status: transaction.transactionStatus),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: CupertinoColors.systemGreen,
          ),
        ),
      ],
    );
  }

  String _dateFormatter({required DateTime date}) {
    String formattedDateTime = DateFormat("yyyy-MM-dd' 'HH:mm").format(date);
    return formattedDateTime;
  }

  String _orderStatus({required int status}) {
    if (status == 3) {
      return 'Complete';
    }
    if (status == 1) {
      return 'Pending';
    }
    return '';
  }
}
