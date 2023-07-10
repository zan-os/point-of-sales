import 'package:common/model/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

import '../const/colors_constants.dart';

class CategoryPicker extends StatefulWidget {
  final Function(CategoryModel) onSelectButtonTap;
  final List<CategoryModel> categories;

  const CategoryPicker({
    super.key,
    required this.onSelectButtonTap,
    required this.categories,
  });

  @override
  State<CategoryPicker> createState() => CategoryPickerState();
}

class CategoryPickerState extends State<CategoryPicker> {
  int _selectedCategoryPosition = 0;
  CategoryModel _categoryModel = CategoryModel();

  late Size _size;

  final Widget title = const Text(
    'Pilih Kategori',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget categoryList() {
    return SizedBox(
      height: _size.height * 0.37,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        padding: const EdgeInsets.only(bottom: 8.0),
        itemCount: widget.categories.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => setState(
            () {
              _selectedCategoryPosition = index;
              _categoryModel = widget.categories[index];
            },
          ),
          child: _CategoryItemCard(
            categoryName: widget.categories[index].name ?? '',
            index: index,
            selectedCategoryPosition: _selectedCategoryPosition,
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _size.height * 0.55,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            title,
            categoryList(),
            RoundedButtonWidget(
              title: 'Pilih Kategori',
              onTap: () => {
                widget.onSelectButtonTap(_categoryModel),
                Navigator.pop(context)
              },
            )
          ],
        ),
      ),
    );
  }
}

class _CategoryItemCard extends StatelessWidget {
  final int index;
  final int selectedCategoryPosition;
  final String categoryName;

  const _CategoryItemCard({
    required this.index,
    required this.selectedCategoryPosition,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _handleSelectedCategory(selectedCategoryPosition, index),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            width: 25,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: _handleSelectedCategory(selectedCategoryPosition, index),
            ),
          ),
          const SizedBox(width: 16.0),
          Text(
            categoryName,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Color _handleSelectedCategory(selectedCategoryPosition, index) =>
      selectedCategoryPosition == index
          ? ColorConstants.primaryYellow
          : Colors.grey.shade300;
}
