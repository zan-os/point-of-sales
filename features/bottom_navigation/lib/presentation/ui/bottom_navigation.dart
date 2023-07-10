import 'dart:developer';

import 'package:cart/presentation/ui/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:home/presentation/ui/home_screen.dart';
import 'package:invoice/presentation/ui/invoice_screen.dart';
import 'package:product_list/presentation/ui/product_list_screen.dart';
import 'package:profile/presentation/ui/profile_screen.dart';

import '../widgets/fluid_bottom_navbar.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  Widget _child = Container();
  int _selectedIndex = 0;
  Map<String, String> arguments = {};

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        arguments =
            ModalRoute.of(context)?.settings.arguments as Map<String, String>;

        if (arguments['role'] == 'ADMIN') {
          _child = HomeScreen(email: arguments['email'] ?? '');
        }
        if (arguments['role'] == 'CASHIER') {
          _child = const Center(
            child: Text('InvoicePage'),
          );
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: _child,
      bottomNavigationBar: FluidBottomNavigationBar(
        role: arguments['role'] ?? 'CASHIER',
        onChange: (index) {
          if (arguments['role'] == 'ADMIN') {
            _handleAdminRole(index, arguments);
          } else if (arguments['role'] == 'CASHIER') {
            _handleCashierRole(index, arguments);
          } else {
            return;
          }
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }

  void _handleAdminRole(int index, Map<String, String> arguments) {
    log('ojan executed');
    setState(
      () {
        switch (index) {
          case 0:
            log('ojan 0');
            _child = HomeScreen(email: arguments['email'] ?? 'Unknown');
            _selectedIndex = index;
            break;
          case 1:
            log('ojan 1');
            _child = const InvoiceScreen();
            _selectedIndex = index;
            break;
          case 2:
            log('ojan 2');
            _child = const ProductListScreen(isAdmin: true);
            _selectedIndex = index;
            break;
          case 3:
            log('ojan 3');
            _child = const CartScreen();
            _selectedIndex = index;
            break;
          case 4:
            log('ojan 4');
            _child = ProfileScreen(
              email: arguments['email'] ?? 'null',
              role: arguments['role'] ?? 'null',
            );
            _selectedIndex = index;
            break;
        }
      },
    );
  }

  void _handleCashierRole(int index, Map<String, String> arguments) {
    log('ojan executed');
    setState(
      () {
        switch (index) {
          case 0:
            log('ojan 1');
            _child = const InvoiceScreen();
            _selectedIndex = index;
            break;
          case 1:
            log('ojan 2');
            _child = const ProductListScreen(isAdmin: false);
            _selectedIndex = index;
            break;
          case 2:
            log('ojan 3');
            _child = const CartScreen();
            _selectedIndex = index;
            break;
          case 3:
            log('ojan 4');
            _child = ProfileScreen(
              email: arguments['email'] ?? 'null',
              role: arguments['role'] ?? 'null',
            );
            _selectedIndex = index;
            break;
        }
      },
    );
  }
}
