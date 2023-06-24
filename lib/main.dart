import 'package:auth/presentation/ui/auth_screen.dart';
import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

import 'presentation/theme/app_theming.dart';
import 'presentation/ui/shell_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo', theme: appTheming(), home: const AuthScreen()
        // home: const ShellScreen(),
        );
  }
}
