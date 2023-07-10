import 'package:flutter/material.dart';

import '../const/colors_constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome;
  final String title;
  final bool enableAction;
  final bool enableLeading;
  const AppBarWidget({
    super.key,
    required this.isHome,
    required this.title,
    this.enableAction = true,
    this.enableLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isHome ? null : Colors.transparent,
      leading: isHome || !enableLeading
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
                  Navigator.pop(context);
                },
              ),
            ),
      elevation: 0.0,
      centerTitle: (isHome) ? false : true,
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
