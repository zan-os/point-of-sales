import 'package:add_cashier/presentation/ui/add_cashier_screen.dart';
import 'package:add_product/presentation/ui/add_product_screen.dart';
import 'package:auth/presentation/ui/auth_screen.dart';
import 'package:bottom_navigation/presentation/ui/bottom_navigation.dart';
import 'package:common/navigation/app_router.dart';
import 'package:dependencies/supabase/supabase.dart';
import 'package:flutter/material.dart';

import 'presentation/theme/app_theming.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qfcfviouxxtwfutjzbxw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmY2Z2aW91eHh0d2Z1dGp6Ynh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQ5NzYzOTQsImV4cCI6MjAwMDU1MjM5NH0.OKoT6siTw9VXOFcFPpaTz3dJuDp5ZLc0eSNeofTdi2s',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheming(),
      home: const AuthScreen(),
      initialRoute: AppRouter.auth,
      routes: {
        AppRouter.main: (context) => const BottomNavigationScreen(),
        AppRouter.addProduct: (context) => AddProductScreen(),
        AppRouter.auth: (context) => AuthScreen(),
        AppRouter.addCashier: (context) => AddCashierScreen(),
      },
    );
  }
}
