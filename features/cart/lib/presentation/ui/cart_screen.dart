import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
        child: SingleChildScrollView(
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
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return const ProductListTile();
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
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: ColorConstants.greyColor),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Total Pembayaran'),
                    Text('Rp.100.000')
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RoundedButtonWidget(title: 'Bayar', onTap: () {}),
                )
              ],
            ),
          ),
        ),
      );
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
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
                  'https://picsum.photos/seed/418/600',
                  width: 80,
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        ' Wortel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.blackColor,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(' Rp. 12.000'),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  Text('Jumlah'),
                  SizedBox(height: 16.0),
                  Text('4'),
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
