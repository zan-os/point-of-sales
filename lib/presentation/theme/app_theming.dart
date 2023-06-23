import 'package:ui/ui.dart';

ThemeData appTheming() {
  return ThemeData(
    fontFamily: 'Sans Serif',
    brightness: Brightness.light,
    appBarTheme: appBarTheming(),
    textTheme: textTheming(),
  );
}

AppBarTheme appBarTheming() {
  return AppBarTheme(
    iconTheme: IconThemeData(color: ColorConstants.greyColor),
    color: ColorConstants.primaryYellow,
  );
}

TextTheme textTheming() {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: 96.0,
      color: ColorConstants.greyColor,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontSize: 60.0,
      color: ColorConstants.greyColor,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      fontSize: 48.0,
      color: ColorConstants.greyColor,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontSize: 34.0,
      color: ColorConstants.greyColor,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.0,
      color: ColorConstants.greyColor,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontSize: 20.0,
      color: ColorConstants.greyColor,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      color: ColorConstants.greyColor,
    ),
    titleSmall: TextStyle(
      fontSize: 14.0,
      color: ColorConstants.greyColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: ColorConstants.greyColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: ColorConstants.greyColor,
    ),
    labelLarge: TextStyle(
        fontSize: 14.0,
        color: ColorConstants.greyColor,
        fontWeight: FontWeight.bold),
    bodySmall: TextStyle(
      fontSize: 12.0,
      color: ColorConstants.greyColor,
    ),
    labelSmall: TextStyle(
      fontSize: 10.0,
      color: ColorConstants.greyColor,
    ),
  );
}
