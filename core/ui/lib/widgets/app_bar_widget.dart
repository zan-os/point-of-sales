import 'package:flutter/material.dart';

import '../const/colors_constants.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final bool isHome;
  final String title;
  final bool enableAction;
  const AppBarWidget({
    super.key,
    required this.isHome,
    required this.title,
    this.enableAction = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isHome ? null : Colors.transparent,
      leading: isHome
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isHome
                      ? ColorConstants.brownColor
                      : ColorConstants.blackColor,
                ),
                onPressed: () {
                  // Aksi ketika tombol leading ditekan
                },
              ),
            ),
      elevation: 0.0,
      centerTitle: (isHome) ? false : true,
      actions: [
        (enableAction)
            ?
            // Notification bell icon
            Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Icon(
                  Icons.notifications,
                  color: isHome
                      ? ColorConstants.brownColor
                      : ColorConstants.blackColor,
                ),
              )
            : Container()
      ],
      title: Text(
        title,
        style: TextStyle(
          color: isHome ? ColorConstants.brownColor : ColorConstants.blackColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
