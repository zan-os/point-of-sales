import 'package:cart/presentation/bloc/cart_cubit.dart';
import 'package:cart/presentation/bloc/cart_state.dart';
import 'package:common/navigation/app_router.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:common/utils/currency_formatter.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/loading_animation/loading_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/helper/show_snackbar.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/product_list_tile.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (context) => CartCubit(),
      child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child:const _CartScreenContent()),
    );
  }
}

class _CartScreenContent extends StatefulWidget {
  const _CartScreenContent();

  @override
  State<_CartScreenContent> createState() => _CartScreenContentState();
}

class _CartScreenContentState extends State<_CartScreenContent> {
  late CartCubit cubit;
  bool enableButton = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => cubit.init());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    cubit = context.read<CartCubit>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        isHome: false,
        enableLeading: false,
        title: 'Ringkasan Pemesanan',
        enableAction: false,
      ),
      body: _scaffoldBody(),
    );
  }

  Widget _scaffoldBody() => SafeArea(
        child: BlocConsumer<CartCubit, CartState>(
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
            if (state.status == CubitState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                showSnackBar(state.message, isError: true),
              );
            }
            if (state.status == CubitState.success) {
              (state.createdTransactionId != 0)
                  ? Navigator.pushNamed(
                      context,
                      AppRouter.transaction,
                      arguments: {
                        'transaction_id': state.createdTransactionId,
                        'total_bill': state.totalBill
                      },
                    ).then((value) => cubit.init())
                  : ScaffoldMessenger.of(context).showSnackBar(
                      showSnackBar('Gagal mendapatkan id transaksi',
                          isError: true),
                    );
            }
            if (state.status == CubitState.hasData) {
              setState(() {
                enableButton = true;
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Ordered Product Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'List Pesanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.blackColor,
                          ),
                        ),
                        if (state.cartDetail.isNotEmpty) ...{
                          GestureDetector(
                            onTap: () => cubit.deleteAllCart(),
                            child: const Text(
                              'Kosongkan Cart',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: CupertinoColors.systemRed,
                              ),
                            ),
                          ),
                        }
                      ],
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
                      padding: EdgeInsets.only(top: 8.0),
                      child: Divider(color: ColorConstants.greyColor),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.cartDetail.length,
                      itemBuilder: (context, index) {
                        final category = state.cartDetail[index];
                        final totalPrice = category.totalPrice ?? 0;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(category.product?.name ?? ''),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(formatRupiah(totalPrice)),
                            ),
                          ],
                        );
                      },
                    ),
                    const Divider(color: ColorConstants.greyColor),
                    const SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Tagihan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.blackColor,
                          ),
                        ),
                        Text(
                          formatRupiah(state.totalBill),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.blackColor,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RoundedButtonWidget(
                        enable: state.cartDetail.isNotEmpty,
                        title: 'Bayar',
                        onTap: () {
                          if (state.cartDetail.isNotEmpty && enableButton) {
                            cubit.createOrder();
                          }
                          return;
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );

  ListView _buildOrderedItem(CartState state) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: state.cartDetail.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final cart = state.cartDetail[index];

        return ProductListTile(
          inCart: true,
          image: cart.product?.image ?? '',
          productName: cart.product?.name,
          productPrice: cart.productPrice ?? 0,
          productQty: cart.cartQty.toString(),
          onAddTap: () {
            cubit.addItemCart(product: cart.product!);
          },
          onMinTap: () {
            if (cart.cartQty! <= 1) {
              cubit.deleteItem(id: cart.id!);
              return;
            } else {
              cubit.removeItemCart(product: cart.product!);
            }
          },
        );
      },
    );
  }
}
