import 'package:flutter/material.dart';

class FeatureGridModel {
  final IconData icon;
  final String title;
  final String page;

  const FeatureGridModel({
    this.icon = Icons.broken_image,
    this.title = '',
    this.page = '',
  });
}
