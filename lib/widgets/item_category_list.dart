import 'package:flutter/material.dart';

import '../models/item_category.dart';
import 'item_category_tile.dart';

typedef OnItemCategorySelected = void Function(ItemCategory);

class ItemCategoryList extends StatefulWidget {
  const ItemCategoryList({
    Key key,
    @required this.categories,
    this.initialIndex = 0,
    this.onSelected,
  });

  final int initialIndex;
  final List<ItemCategory> categories;
  final OnItemCategorySelected onSelected;

  @override
  _ItemCategoryListState createState() => _ItemCategoryListState();
}

class _ItemCategoryListState extends State<ItemCategoryList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18.0),
      height: 120,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.0),
        itemBuilder: (_, int i) => SizedBox(
          width: 100,
          child: ItemCategoryTile(
            // isSelected: ,
            itemCategory: widget.categories[i],
            onSelected: widget.onSelected,
          ),
        ),
      ),
    );
  }
}
