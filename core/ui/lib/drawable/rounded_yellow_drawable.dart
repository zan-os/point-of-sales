import '../ui.dart';

class RoundedYellowDrawable extends StatelessWidget {
  const RoundedYellowDrawable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 130.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          color: ColorConstants.primaryYellow,
        ),
      ),
    );
  }
}
