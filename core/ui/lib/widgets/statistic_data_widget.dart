import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';

class StatisticDataWidget extends StatelessWidget {
  final int tProduct, tOutOfStock, tTransaction;
  final String tIncome;
  const StatisticDataWidget({
    super.key,
    this.tProduct = 0,
    this.tOutOfStock = 0,
    this.tTransaction = 0,
    this.tIncome = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildStatisticWidget(tProduct.toString(), 'Total Produk'),
            _buildStatisticWidget(tOutOfStock.toString(), 'Produk yang habis'),
          ],
        ),
        const SizedBox(height: 8.0),
        const Divider(thickness: 1.0),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildStatisticWidget(tTransaction.toString(), 'Total Transaksi'),
            _buildStatisticWidget(tIncome.toString(), 'Total Pemasukan'),
          ],
        ),
      ],
    );
  }

  Column _buildStatisticWidget(String count, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 16.0,
            color: ColorConstants.primaryYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            color: ColorConstants.greyColor,
          ),
        ),
      ],
    );
  }
}
