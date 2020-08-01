import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_category.dart';
import '../screens/item_detail_screen.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
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
          itemBuilder: (_, int i) {
            final item = itemCategory.items[i];
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
                  builder: (_, int quantity, __) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: ItemTile(),
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
          },
        )
      ],
    );
  }
}
