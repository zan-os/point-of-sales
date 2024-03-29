import 'package:common/navigation/app_router.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/loading_animation/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:stock/presentation/cubit/stock_cubit.dart';
import 'package:stock/presentation/cubit/stock_state.dart';
import 'package:ui/helper/show_snackbar.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/rounded_product_container.dart';

import '../../../data/model/stock_model.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unfocusNode = FocusNode();
    return BlocProvider<StockCubit>(
      create: (context) => StockCubit(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
        child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: const _StockScreenContent()),
      ),
    );
  }
}

class _StockScreenContent extends StatefulWidget {
  const _StockScreenContent();

  @override
  State<_StockScreenContent> createState() => __StockScreenContentState();
}

class __StockScreenContentState extends State<_StockScreenContent> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final backgroundColor = Colors.grey[20];
  late StockCubit cubit;

  late TextEditingController _searchController;

  int? categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) => cubit.init());
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    cubit = context.read<StockCubit>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _productGrid({required List<StockModel> stockList}) {
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
        itemCount: stockList.length,
        itemBuilder: (context, index) {
          final stock = stockList[index];
          return _productItem(
            context: context,
            stock: stock,
          );
        },
      ),
    );
  }

  Widget _productItem({
    required BuildContext context,
    required StockModel stock,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: RoundedProductContainer(
        onProductTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.stockManager,
            arguments: stock,
          ).then((value) => cubit.fetchProductList());
        },
        name: stock.productName,
        price:stock.productPrice,
        image: stock.productImage,
        isStockManager: true,
        stock: stock.stockQty.toString(),
      ),
    );
  }

  Widget _scaffoldBody() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: BlocConsumer<StockCubit, StockState>(
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
        },
        builder: (context, state) => Column(
          children: [
            _productGrid(stockList: state.stockList),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        isHome: false,
        title: 'Stock List',
        enableLeading: true,
      ),
      body: _scaffoldBody(),
    );
  }
}
