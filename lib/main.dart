import 'package:add_product/presentation/ui/add_product_screen.dart';
import 'package:auth/presentation/ui/auth_screen.dart';
import 'package:bottom_navigation/presentation/ui/bottom_navigation.dart';
import 'package:common/navigation/app_router.dart';
import 'package:flutter/material.dart';

import 'presentation/theme/app_theming.dart';

void main() {
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
          AppRouter.auth: (context) => AuthScreen()
        }
        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case AppRouter.main:
        //       return MaterialPageRoute(
        //         builder: (context) => BottomNavigationScreen(),
        //       );
        //     case AppRouter.auth:
        //       return MaterialPageRoute(
        //         builder: (context) => AuthScreen(),
        //       );
        //     case AppRouter.addProduct:
        //       return MaterialPageRoute(
        //         builder: (context) => AddProductScreen(),
        //       );
        //     default:
        //       log('ojan null nav');
        //       return null;
        //   }
        // },
        );
  }
}
