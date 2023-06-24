import '../ui.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  const RoundedButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.primaryYellow),
        onPressed: () async {
          onTap();
        },
        child: Text(title),
      ),
    );
  }
}
