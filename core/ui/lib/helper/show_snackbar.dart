import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SnackBar showSnackBar(String message, {required bool isError}) {
  return SnackBar(
    content: Text(message),
    backgroundColor:
        isError ? CupertinoColors.systemRed : CupertinoColors.systemGreen,
    duration: const Duration(seconds: 4),
  );
}
