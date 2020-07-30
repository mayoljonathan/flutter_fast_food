import 'package:fast_food/screens/item_detail_screen.dart';
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
          itemBuilder: (_, int i) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                builder: (_) => ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: mqd.size.height - mqd.viewPadding.top,
                  ),
                  child: ItemDetailScreen(
                    item: itemCategory.items[i],
                  ),
                ),
              );
            },
            child: ItemTile(item: itemCategory.items[i]),
          ),
        )
      ],
    );
  }
}
