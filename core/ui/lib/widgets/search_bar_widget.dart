import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';

import '../drawable/rounded_white_drawable.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSubmitted;
  final Function(String) onTap;
  final Function(String) onChanged;
  final TextEditingController controller;
  const SearchBarWidget({
    super.key,
    required this.onSubmitted,
    required this.onTap,
    required this.controller, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainerDrawable(
      radius: 50.0,
      padding: 0.0,
      onTap: () {},
      child: TextField(
        onSubmitted: (value) => onSubmitted(value),
        onChanged: (value) => onChanged(value),
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search',
          hintStyle: const TextStyle(color: ColorConstants.greyColor),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => onTap(controller.text.trim()),
              child: const CircleAvatar(
                backgroundColor: ColorConstants.primaryYellow,
                child: Icon(
                  Icons.search,
                  color: ColorConstants.whiteBackground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
