import 'package:common/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';

class ProductListTile extends StatelessWidget {
  final String? image;
  final String? productName;
  final int? productPrice;
  final String? productQty;
  final bool inCart;
  final Function? onAddTap;
  final Function? onMinTap;

  const ProductListTile({
    super.key,
    required this.image,
    required this.productName,
    required this.productPrice,
    required this.productQty,
    this.inCart = false,
    this.onAddTap,
    this.onMinTap,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Jumlah'),
                  const SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (inCart)
                        InkWell(
                          onTap: () {
                            if (onAddTap != null) {
                              onAddTap!();
                            }
                          },
                          child: const Icon(Icons.add_rounded),
                        )
                      else
                        const SizedBox.shrink(),
                      const SizedBox(width: 6.0),
                      Text(
                        productQty ?? '0',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 6.0),
                      if (inCart)
                        InkWell(
                          onTap: () {
                            if (onMinTap != null) {
                              onMinTap!();
                            }
                          },
                          child: const Icon(Icons.remove),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
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
