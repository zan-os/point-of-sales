import '../ui.dart';

class RoundedContainerDrawable extends StatelessWidget {
  final Widget? child;
  final double? padding, radius;
  final Function? onTap;
  final Color? color;
  const RoundedContainerDrawable({
    Key? key,
    this.child,
    this.padding,
    this.onTap,
    this.radius,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderOnForeground: true,
      color: ColorConstants.whiteBackground,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10.0)),
      elevation: 1,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: padding ?? 24.0,
          vertical: padding ?? 24.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10.0)),
          color: color ?? ColorConstants.whiteBackground,
        ),
        child: (onTap == null)
            ? child
            : Material(
                type: MaterialType.transparency,
                child: Ink(
                  child: InkWell(onTap: () {}, child: child),
                ),
              ),
      ),
    );
  }
}
