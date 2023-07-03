import 'dart:io';

import 'package:common/utils/currency_formatter.dart';
import 'package:dependencies/cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../drawable/rounded_white_drawable.dart';

class RoundedProductContainer extends StatelessWidget {
  final String? image;
  final File? path;
  final String? name;
  final int? price;
  final Function? addButtonTap;
  const RoundedProductContainer({
    super.key,
    this.image,
    this.name,
    this.price,
    this.path,
    this.addButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 20;

    return RoundedContainerDrawable(
      radius: borderRadius,
      padding: 0,
      onTap: () {},
      child: Stack(
        children: [
          _buildImage(),
          _buildAddButton(borderRadius),
          _buildProductInfo(),
        ],
      ),
    );
  }

  Align _buildProductInfo() {
    return Align(
      alignment: const AlignmentDirectional(-1, 1),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
              child: Text(
                name ?? '-',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(formatRupiah(price)),
          ],
        ),
      ),
    );
  }

  Align _buildAddButton(double borderRadius) {
    return Align(
      alignment: const AlignmentDirectional(1, 1),
      child: GestureDetector(
        onTap: () {
          if (addButtonTap != null) {
            addButtonTap!();
          }
        },
        child: Container(
          width: 59,
          height: 59,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCC68),
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(0),
              bottomRight: Radius.circular(borderRadius),
              topLeft: Radius.circular(borderRadius),
              topRight: const Radius.circular(0),
            ),
          ),
          child: const Align(
            alignment: AlignmentDirectional(0, 0),
            child: Icon(
              Icons.add_box_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildImage() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 58),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: (path == null)
            ? CachedNetworkImage(
                imageUrl: image ?? '',
                width: 215,
                height: 176,
                filterQuality: FilterQuality.none,
                maxHeightDiskCache: 176,
                memCacheHeight: 176,
                memCacheWidth: 215,
                placeholder: (context, url) => (image == null)
                    ? const Center(child: Text('Image'))
                    : const SizedBox.shrink(),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              )
            : Image.file(
                path!,
                width: 215,
                height: 176,
              ),
      ),
    );
  }
}
