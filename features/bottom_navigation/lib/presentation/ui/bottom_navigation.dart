import 'dart:developer';

import 'package:cart/presentation/ui/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:home/presentation/ui/home_screen.dart';
import 'package:product_list/presentation/ui/product_list.dart';
import 'package:profile/presentation/ui/profile_screen.dart';

import '../widgets/fluid_bottom_navbar.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  Widget? _child;
  int _selectedIndex = 0;

  @override
  void initState() {
    _child = const HomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: _child,
      bottomNavigationBar: FluidBottomNavigationBar(
        onChange: (index) {
          _handleNavigationChange(index);
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }

  void _handleNavigationChange(int index) {
    log('ojan executed');
    setState(
      () {
        switch (index) {
          case 0:
            log('ojan 0');
            _child = const HomeScreen();
            _selectedIndex = index;
            break;
          case 1:
            log('ojan 1');
            _child = const Center(
              child: Text('InvoicePage'),
            );
            _selectedIndex = index;
            break;
          case 2:
            log('ojan 2');
            _child = const ProductListScreen();
            _selectedIndex = index;
            break;
          case 3:
            log('ojan 3');
            _child = CartScreen();
            _selectedIndex = index;
            break;
          case 4:
            log('ojan 4');
            _child = ProfileScreen();
            _selectedIndex = index;
            break;
        }
      },
    );
  }
}
