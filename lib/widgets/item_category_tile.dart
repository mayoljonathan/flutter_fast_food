import 'package:flutter/material.dart';

import '../models/item_category.dart';
import 'item_category_list.dart';

class ItemCategoryTile extends StatelessWidget {
  const ItemCategoryTile({
    Key key,
    @required this.itemCategory,
    this.isSelected = false,
    this.selectedColor,
    this.onSelected,
  });

  final ItemCategory itemCategory;
  final bool isSelected;
  final Color selectedColor;
  final OnItemCategorySelected onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9.0),
      child: Material(
        color: !isSelected ? Colors.grey.shade100 : selectedColor,
        child: InkWell(
          onTap: onSelected != null ? () => onSelected(itemCategory) : null,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Image.asset(
                  itemCategory.imageUrl,
                  height: 64,
                  width: 64,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      itemCategory.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: !isSelected ? null : Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
