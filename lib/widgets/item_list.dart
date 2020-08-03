import 'package:fast_food/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_category.dart';
import '../screens/item_detail_screen.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
import 'item_tile.dart';

enum ItemListLayout { list, grid }

class ItemList extends StatelessWidget {
  const ItemList({
    Key key,
    @required this.itemCategory,
    this.layout = ItemListLayout.list,
    this.showHeader = true,
  });

  final ItemCategory itemCategory;
  final ItemListLayout layout;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox();

    switch (layout) {
      case ItemListLayout.list:
        child = _buildListLayout(context);
        break;
      case ItemListLayout.grid:
        child = _buildGridLayout(context);
        break;
    }

    return child;
  }

  Widget _buildGridLayout(BuildContext context) {
    final MediaQueryData mqd = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) _buildCategoryName(context),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: mqd.size.width / (mqd.size.height / 1.3),
            crossAxisCount: 2,
            crossAxisSpacing: 18.0,
            mainAxisSpacing: 24.0,
          ),
          itemCount: itemCategory.items.length,
          itemBuilder: (_, int i) => _buildItemTile(
            context: context,
            item: itemCategory.items[i],
            layout: ItemTileLayout.layout1,
          ),
        )
      ],
    );
  }

  Widget _buildListLayout(BuildContext context) {
    final MediaQueryData mqd = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) _buildCategoryName(context),
        SizedBox(
          height: 124,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            physics: BouncingScrollPhysics(),
            itemCount: itemCategory.items.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => SizedBox(width: 12.0),
            itemBuilder: (_, int i) => SizedBox(
              width: mqd.size.width * 0.75,
              child: _buildItemTile(
                context: context,
                item: itemCategory.items[i],
                layout: ItemTileLayout.layout3,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCategoryName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Text(
        itemCategory.name,
        style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildItemTile({
    @required BuildContext context,
    @required Item item,
    ItemTileLayout layout = ItemTileLayout.layout1,
  }) {
    final MediaQueryData mqd = MediaQuery.of(context);

    ItemViewModel itemViewModel = ItemViewModel(item: item);
    debugPrint('[ItemBuilder - ${itemViewModel.item.name}] Build once!');

    // When screen rotation/hot reload/widget build occurs, will lose the state of the itemViewModel's quantity
    // So replace the current itemViewModel with the existing itemViewModel from the cart
    final CartViewModel cartViewModel = context.read<CartViewModel>();
    itemViewModel = cartViewModel.getItemInCart(itemViewModel) ?? itemViewModel;

    return ChangeNotifierProvider<ItemViewModel>.value(
      value: itemViewModel,
      child: Builder(
        builder: (context) => Selector<ItemViewModel, int>(
          selector: (_, model) => model.quantity,
          builder: (_, int quantity, __) => InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: ItemTile(
              layout: layout,
            ),
            onTap: () async {
              int updatedQuantity = await showModalBottomSheet<int>(
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
                    item: item,
                    initialQuantity: quantity,
                  ),
                ),
              );

              if (updatedQuantity != null) {
                itemViewModel.setQuantity(updatedQuantity);
                cartViewModel.addOrUpdateToCart(itemViewModel);
              }
            },
          ),
        ),
      ),
    );
  }
}
