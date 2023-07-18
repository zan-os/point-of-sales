import 'package:common/navigation/app_router.dart';
import 'package:common/utils/currency_formatter.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:home/data/model/feature_grid_model.dart';
import 'package:home/presentation/cubit/home_cubit.dart';
import 'package:home/presentation/cubit/home_state.dart';
import 'package:ui/drawable/rounded_white_drawable.dart';
import 'package:ui/drawable/rounded_yellow_drawable.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/statistic_data_widget.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  final String role;
  const HomeScreen({
    super.key,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: HomeScreenContent(
            email: email,
            role: role,
          )),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  final String email;
  final String role;
  const HomeScreenContent({
    Key? key,
    required this.email,
    required this.role,
  }) : super(key: key);

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  late HomeCubit cubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    cubit = context.read<HomeCubit>();
    cubit.init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        isHome: true,
        title: 'Hello ${widget.email}',
        enableLeading: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildHomeHeader(),
            _buildHomeBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeBody() {
    return ListView(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatisticData(),
        const SizedBox(
          height: 10.0,
        ),
        _buildGridView(),
        const SizedBox(height: 14.0),
      ],
    );
  }

  // Showing features as a grid view
  GridView _buildGridView() {
    final List<FeatureGridModel> adminGridItem = [
      const FeatureGridModel(
        icon: Icons.add_box_outlined,
        title: 'Tambah Produk',
        page: AppRouter.addProduct,
      ),
      const FeatureGridModel(
        icon: Icons.add_business_outlined,
        title: 'Tambah Pegawai',
        page: AppRouter.addCashier,
      ),
      const FeatureGridModel(
          icon: Icons.stacked_bar_chart_outlined,
          title: 'Atur Stok',
          page: AppRouter.stock),
    ];

    final List<FeatureGridModel> cashierGridItem = [
      const FeatureGridModel(
        icon: Icons.add_box_outlined,
        title: 'List Produk',
        page: AppRouter.productList,
      ),
      const FeatureGridModel(
        icon: Icons.library_books_outlined,
        title: 'List Transaksi',
        page: AppRouter.invoice,
      )
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: (widget.role == 'ADMIN')
          ? adminGridItem.length
          : cashierGridItem.length,
      itemBuilder: (context, index) {
        final item = (widget.role == 'ADMIN')
            ? adminGridItem[index]
            : cashierGridItem[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedContainerDrawable(
            onTap: () {
              if (item.page.isNotEmpty) {
                Navigator.pushNamed(context, item.page);
              }
            },
            padding: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Set the icon/logo of features from here
                Icon(item.icon, size: 40.0),
                const SizedBox(height: 14.0),
                // Set the title of features from here
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Showing rounded yellow drawable as a background
  Widget _buildHomeHeader() {
    return const RoundedYellowDrawable();
  }

  // Showing statistic data
  Widget _buildStatisticData() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => RoundedContainerDrawable(
        onTap: () {},
        child: StatisticDataWidget(
          // Set amount of statistic data from here
          tProduct: state.totalProduct,
          tOutOfStock: state.outOfStockProduct,
          tTransaction: state.totalOrder,
          tIncome: formatRupiah(state.totalIncome),
        ),
      ),
    );
  }
}
