import 'package:flutter/material.dart';
import 'package:home/data/model/feature_grid_model.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/drawable/rounded_white_drawable.dart';
import 'package:ui/drawable/rounded_yellow_drawable.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/pending_action_tile_widget.dart';
import 'package:ui/widgets/statistic_data_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        isHome: true,
        title: 'Hello Ozan!',
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
    return SafeArea(
      child: ListView(
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
          const Text(
            'Order waiting  to be processed',
            style: TextStyle(fontSize: 16.0, color: ColorConstants.greyColor),
          ),
          const SizedBox(height: 16.0),
          _buildPendingActionTile()
        ],
      ),
    );
  }

  Widget _buildPendingActionTile() {
    return RoundedContainerDrawable(
      padding: 16.0,
      onTap: () {},
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: const [
          PendingActionTileWidget(
            title: 'Waiting for approval',
            count: '10',
          ),
          SizedBox(height: 4.0),
          Divider(),
          SizedBox(height: 4.0),
          PendingActionTileWidget(
            title: 'Waiting for payment',
            count: '5',
          ),
          SizedBox(height: 4.0),
          Divider(),
          SizedBox(height: 4.0),
          PendingActionTileWidget(
            title: 'Waiting to be shipped',
            count: '10',
          ),
        ],
      ),
    );
  }

  // Showing features as a grid view
  GridView _buildGridView() {
    // Dummy features data
    final List<FeatureGridModel> gridItem = [
      const FeatureGridModel(
        icon: Icons.add_box_outlined,
        title: 'Tambah Produk',
        page: '/add-product',
      ),
      const FeatureGridModel(
        icon: Icons.add_business_outlined,
        title: 'Tambah Pegawai',
        page: '/add-cashier',
      ),
      const FeatureGridModel(
        icon: Icons.stacked_bar_chart_outlined,
        title: 'Add Stock',
      ),
      const FeatureGridModel(
        icon: Icons.view_list_sharp,
        title: 'List Order',
      ),
      const FeatureGridModel(
        icon: Icons.receipt_long_outlined,
        title: 'Report',
      ),
      const FeatureGridModel(
        icon: Icons.person_pin_outlined,
        title: 'Absen',
      ),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: gridItem.length,
      itemBuilder: (context, index) {
        final item = gridItem[index];

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
    return RoundedContainerDrawable(
      onTap: () {},
      child: const StatisticDataWidget(
        // Set amount of statistic data from here
        tOrder: 15,
        tDistribution: 7,
        tNewOrder: 4,
        tCanceled: 0,
      ),
    );
  }
}
