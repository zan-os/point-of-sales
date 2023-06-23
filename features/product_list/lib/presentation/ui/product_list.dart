import 'dart:developer';

import 'package:ui/ui.dart';

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
    const double borderRadius = 20;
    return RoundedContainerDrawable(
      radius: borderRadius,
      padding: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 58),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: Image.network(
                'https://picsum.photos/seed/418/600',
                width: 210,
                height: 176,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(1, 1),
            child: Container(
              width: 59,
              height: 59,
              decoration: const BoxDecoration(
                color: Color(0xFFFFCC68),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(borderRadius),
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(0),
                ),
              ),
              child: const Align(
                alignment: AlignmentDirectional(0, 0),
                child: Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-1, 1),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Text(
                      'Wortel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('Rp. 25.000'),
                ],
              ),
            ),
          ),
        ],
      ),
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
          title: 'Product',
        ),
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        body: SafeArea(child: _buildBody()),
      ),
    );
  }
}
