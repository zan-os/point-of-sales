import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/rounded_product_container.dart';
import 'package:ui/widgets/search_bar_widget.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();
  final backgroundColor = Colors.grey[20];
  final categories = ['All', 'Vegetable', 'Fruit', 'Seafood', 'Meat', 'Drinks'];

  TextEditingController? _searchController;

  int? categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: Column(
        children: [
          _buildSearchAndFilter(),
          _buildCategoryList(),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          childAspectRatio: 4 / 4.6,
        ),
        shrinkWrap: true,
        itemCount: 11,
        itemBuilder: (context, index) {
          return _buildProductItem(context);
        },
      ),
    );
  }

  Widget _buildProductItem(BuildContext context) {
    return const RoundedProductContainer(
      name: 'Wortel',
      price: '12.000',
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
      child: Container(
        width: double.infinity,
        height: 30,
        decoration: const BoxDecoration(),
        child: ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryItem(index: index, name: category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem({int index = 0, String? name}) {
    const double horizontalPadding = 10.0;
    const double verticalPadding = 6.0;
    return GestureDetector(
      onTap: () {
        setState(() {
          categoryIndex = index;
        });
        log('index ==> $categoryIndex');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color:
                (categoryIndex == index) ? ColorConstants.primaryYellow : null,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: (categoryIndex == index)
                  ? const Color(0x00000000)
                  : const Color(0xFFD5D5D5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              horizontalPadding,
              verticalPadding,
              horizontalPadding,
              verticalPadding,
            ),
            child: Text(
              name ?? '',
              style: TextStyle(
                  color: (categoryIndex == index)
                      ? ColorConstants.whiteBackground
                      : null),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildSearchWidget(),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCC68),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return const Expanded(child: SearchBarWidget());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
      child: Scaffold(
        appBar: const AppBarWidget(
          isHome: false,
          title: 'Product',enableLeading: false,
        ),
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        body: SafeArea(child: _buildBody()),
      ),
    );
  }
}
