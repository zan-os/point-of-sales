import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';

import '../drawable/rounded_white_drawable.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainerDrawable(
      radius: 50.0,
      padding: 0.0,
      onTap: () {},
      child: const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search',
          hintStyle: TextStyle(color: ColorConstants.greyColor),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: ColorConstants.primaryYellow,
              child: Icon(
                Icons.search,
                color: ColorConstants.whiteBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
