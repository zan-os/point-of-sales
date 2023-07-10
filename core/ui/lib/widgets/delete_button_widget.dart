import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteButtonWidget extends StatelessWidget {
  final String title;
  final bool enable;
  final Function onTap;
  const DeleteButtonWidget({
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
          backgroundColor: CupertinoColors.systemRed,
        ),
        onPressed: () {
          onTap();
        },
        child: Text(title),
      ),
    );
  }
}
