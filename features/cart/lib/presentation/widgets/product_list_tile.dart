
import 'package:common/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';

class ProductListTile extends StatelessWidget {
  final String? image;
  final String? productName;
  final int? productPrice;
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
                      Text(formatRupiah(productPrice)),
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
