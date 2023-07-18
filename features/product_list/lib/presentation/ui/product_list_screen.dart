import 'dart:developer';

import 'package:common/model/categories_model.dart';
import 'package:common/model/product_model.dart';
import 'package:common/navigation/app_router.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/loading_animation/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:product_list/presentation/cubit/product_list_cubit.dart';
import 'package:product_list/presentation/cubit/product_list_state.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/helper/show_snackbar.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/rounded_product_container.dart';
import 'package:ui/widgets/search_bar_widget.dart';

class ProductListScreen extends StatelessWidget {
  final bool isAdmin;
  final bool onRoot;
  const ProductListScreen(
      {super.key, this.isAdmin = false, this.onRoot = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductListCubit>(
      create: (context) => ProductListCubit(),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: _ProductListContent(
          isAdmin: isAdmin,
          onRoot: onRoot,
        ),
      ),
    );
  }
}

class _ProductListContent extends StatefulWidget {
  final bool isAdmin;
  final bool onRoot;
  const _ProductListContent({
    Key? key,
    required this.isAdmin,
    required this.onRoot,
  }) : super(key: key);

  @override
  _ProductListContentState createState() => _ProductListContentState();
}

class _ProductListContentState extends State<_ProductListContent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();
  final backgroundColor = Colors.grey[20];
  late ProductListCubit cubit;

  late TextEditingController _searchController;

  int? categoryIndex = 0;

  Widget _scaffoldBody() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: BlocConsumer<ProductListCubit, ProductListState>(
        listener: (context, state) {
          if (state.status == CubitState.loading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.white,
                  size: 50,
                ),
              ),
            );
          }
          if (state.status == CubitState.finishLoading) {
            Navigator.pop(context);
          }
          if (state.status == CubitState.success) {
            ScaffoldMessenger.of(context)
                .showSnackBar(showSnackBar(state.message, isError: false));
          }
          if (state.status == CubitState.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(showSnackBar(state.message, isError: true));
          }

          if (state.status == CubitState.hasData) {
            Future.delayed(const Duration(seconds: 1)).then(
              (value) => Navigator.pushNamed(
                context,
                AppRouter.stockManager,
                arguments: state.stock,
              ).then((value) => cubit.init()),
            );
          }
        },
        builder: (context, state) => Column(
          children: [
            _buildSearchAndFilter(),
            _buildCategoryList(categories: state.categories),
            if (state.productList.isNotEmpty) ...[
              _buildProductGrid(productList: state.productList),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid({required List<ProductModel> productList}) {
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
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return _buildProductItem(context: context, product: product);
        },
      ),
    );
  }

  Widget _buildProductItem(
      {required BuildContext context, required ProductModel product}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: RoundedProductContainer(
        name: product.name,
        price: product.price,
        image: product.image,
        isStockManager: false,
        onRoot: widget.onRoot,
        addButtonTap: () {
          (widget.onRoot) ? cubit.addToCart(product: product) : null;
        },
        onProductTap: () {
          if (widget.isAdmin) {
            (widget.onRoot)
                ? cubit.fetchProductDetail(productId: product.id ?? 0)
                : null;
          }
        },
      ),
    );
  }

  Widget _buildCategoryList({required List<CategoryModel> categories}) {
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
            return _buildCategoryItem(
              index: index,
              name: category.name,
              categoryId: category.id,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem({int index = 0, String? name, int? categoryId}) {
    const double horizontalPadding = 10.0;
    const double verticalPadding = 6.0;
    return GestureDetector(
      onTap: () {
        cubit.fetchByCategory(categoryId: categoryId ?? 0);
        setState(() {
          categoryIndex = index;
        });
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
        ],
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Expanded(
      child: SearchBarWidget(
        controller: _searchController,
        onTap: (value) => cubit.fetchByName(name: value),
        onChanged: (value) => cubit.setSearchedProduct(searchedProduct: value),
        onSubmitted: (value) => cubit.fetchByName(name: value),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) => cubit.init());
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    cubit = context.read<ProductListCubit>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
      child: Scaffold(
        appBar: AppBarWidget(
          onRoot: widget.onRoot,
          isHome: false,
          title: 'Product',
          enableLeading: true,
        ),
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        body: SafeArea(child: _scaffoldBody()),
      ),
    );
  }
}
