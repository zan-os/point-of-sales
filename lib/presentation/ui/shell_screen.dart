import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home/home.dart';
import 'package:product_list/product_list.dart';
import 'package:profile/profile.dart';

import '../widgets/fluid_nav_bar.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  Widget? _child;
  int _selectedIndex = 0;

  @override
  void initState() {
    _child = HomeScreen();
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
            _child = HomeScreen();
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
            _child = ProductListScreen();
            _selectedIndex = index;
            break;
          case 3:
            log('ojan 3');
            _child = const Center(
              child: Text('StorePage'),
            );
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
