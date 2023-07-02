import 'package:cart/presentation/bloc/cart_cubit.dart';
import 'package:cart/presentation/bloc/cart_state.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:common/utils/currency_formatter.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (context) => CartCubit(),
      child: const CartScreenContent(),
    );
  }
}

class CartScreenContent extends StatefulWidget {
  const CartScreenContent({super.key});

  @override
  State<CartScreenContent> createState() => _CartScreenContentState();
}

class _CartScreenContentState extends State<CartScreenContent> {
  late CartCubit cubit;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => cubit.fetchCart());
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() => SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.status == CubitState.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
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
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.cartDetail.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final cart = state.cartDetail[index];

                          return ProductListTile(
                            image: cart.product?.image ?? '',
                            productName: cart.product?.name,
                            productPrice: cart.productPrice.toString(),
                            productQty: cart.cartQty.toString(),
                          );
                        },
                      ),

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
                                child: Text(formatRupiah(
                                    category.totalPrice.toString())),
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
                            'Total Pembayaran',
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
                            title: 'Bayar',
                            onTap: () {
                              cubit.createOrder();
                            }),
                      )
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      );
}

class ProductListTile extends StatelessWidget {
  final String? image;
  final String? productName;
  final String? productPrice;
  final String? productQty;
  const ProductListTile({
    super.key,
    required this.image,
    required this.productName,
    required this.productPrice,
    required this.productQty,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  image ?? 'https://picsum.photos/seed/418/600',
                  width: 80,
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        productName ?? '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.blackColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(productPrice ?? '0'),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('Jumlah'),
                  const SizedBox(height: 16.0),
                  Text(productQty ?? '0'),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(color: ColorConstants.greyColor),
        ),
      ],
    );
  }
}
