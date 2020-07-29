import 'package:flutter/material.dart';

import '../models/item_category.dart';
import 'item_tile.dart';

class ItemGrid extends StatelessWidget {
  const ItemGrid({
    Key key,
    @required this.itemCategory,
  });

  final ItemCategory itemCategory;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mqd = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            itemCategory.name,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: mqd.size.width / (mqd.size.height / 1.2),
            crossAxisCount: 2,
            crossAxisSpacing: 18.0,
            mainAxisSpacing: 24.0,
          ),
          itemCount: itemCategory.items.length,
          itemBuilder: (_, int i) => ItemTile(item: itemCategory.items[i]),
        )
      ],
    );
  }
}
