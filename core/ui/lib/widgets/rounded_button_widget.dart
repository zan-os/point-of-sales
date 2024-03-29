import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors_constants.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String title;
  final bool enable;
  final Function onTap;
  const RoundedButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (enable)
              ? ColorConstants.primaryYellow
              : CupertinoColors.systemGrey4,
        ),
        onPressed: () {
          onTap();
        },
        child: Text(title),
      ),
    );
  }
}
