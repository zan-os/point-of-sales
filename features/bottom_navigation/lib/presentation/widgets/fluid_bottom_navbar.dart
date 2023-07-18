import 'package:dependencies/fluid_bottom_navigation_bar/fluid_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';

class FluidBottomNavigationBar extends StatelessWidget {
  final Function onChange;
  final int? selectedIndex;
  final String role;

  const FluidBottomNavigationBar({
    Key? key,
    required this.onChange,
    required this.selectedIndex,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15.0,
      child: FluidNavBar(
        icons: [
          if (role == 'ADMIN')
            ..._adminIcons()
          else if (role == 'CASHIER')
            ..._cashierIcon()
          else
            ...[],
        ],
        onChange: (selectedIndex) {
          onChange(selectedIndex);
        },
        animationFactor: 0.3,
        style: const FluidNavBarStyle(
            iconUnselectedForegroundColor: ColorConstants.greyColor,
            barBackgroundColor: ColorConstants.whiteBackground,
            iconSelectedForegroundColor: ColorConstants.whiteBackground),
        defaultIndex: 0,
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras!["label"],
          child: item,
        ),
      ),
    );
  }

  List<FluidNavBarIcon> _adminIcons() {
    return [
      FluidNavBarIcon(
          icon: Icons.home_outlined,
          extras: {"label": "Home"},
          backgroundColor: (selectedIndex == 0)
              ? ColorConstants.primaryYellow
              : ColorConstants.whiteBackground),
      FluidNavBarIcon(
          icon: Icons.library_books_outlined,
          extras: {"label": "bookmark"},
          backgroundColor: (selectedIndex == 1)
              ? ColorConstants.primaryYellow
              : ColorConstants.whiteBackground),
      FluidNavBarIcon(
        icon: Icons.shopping_bag_outlined,
        extras: {"label": "partner"},
        backgroundColor: (selectedIndex == 2)
            ? ColorConstants.primaryYellow
            : ColorConstants.whiteBackground,
      ),
      FluidNavBarIcon(
        icon: Icons.shopping_cart_outlined,
        extras: {"label": "conference"},
        backgroundColor: (selectedIndex == 3)
            ? ColorConstants.primaryYellow
            : ColorConstants.whiteBackground,
      ),
      FluidNavBarIcon(
        icon: Icons.person_outline_rounded,
        extras: {"label": "conference"},
        backgroundColor: (selectedIndex == 4)
            ? ColorConstants.primaryYellow
            : ColorConstants.whiteBackground,
      ),
    ];
  }

  List<FluidNavBarIcon> _cashierIcon() {
    return [
      FluidNavBarIcon(
          icon: Icons.home_outlined,
          extras: {"label": "Home"},
          backgroundColor: (selectedIndex == 0)
              ? ColorConstants.primaryYellow
              : ColorConstants.whiteBackground),
      FluidNavBarIcon(
        icon: Icons.shopping_bag_outlined,
        extras: {"label": "partner"},
        backgroundColor: (selectedIndex == 1)
            ? ColorConstants.primaryYellow
            : ColorConstants.whiteBackground,
      ),
      FluidNavBarIcon(
        icon: Icons.shopping_cart_outlined,
        extras: {"label": "conference"},
        backgroundColor: (selectedIndex == 2)
            ? ColorConstants.primaryYellow
            : ColorConstants.whiteBackground,
      ),
      FluidNavBarIcon(
        icon: Icons.person_outline_rounded,
        extras: {"label": "conference"},
        backgroundColor: (selectedIndex == 3)
            ? ColorConstants.primaryYellow
            : ColorConstants.whiteBackground,
      ),
    ];
  }
}
