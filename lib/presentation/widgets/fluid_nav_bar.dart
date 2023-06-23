// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:ui/ui.dart';

class FluidBottomNavigationBar extends StatelessWidget {
  final Function onChange;
  final int? selectedIndex;

  const FluidBottomNavigationBar({
    Key? key,
    required this.onChange,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15.0,
      child: FluidNavBar(
        icons: [
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
        ],
        onChange: (selectedIndex) {
          onChange(selectedIndex);
        },
        animationFactor: 1.5,
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
}
