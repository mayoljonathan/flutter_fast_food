import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
import 'quantity_picker.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemViewModel itemViewModel = context.watch<ItemViewModel>();
    final Item item = itemViewModel.item;

    debugPrint('[ItemTile - ${item.name}] Build once');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              color: Colors.grey.shade100,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  item.imageUrl,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 9.0,
            bottom: 3.0,
          ),
          child: Text(item.name),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PHP ${item.price}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            QuantityPicker(
              key: ObjectKey(item),
              value: itemViewModel.quantity,
              onChanged: (int newQuantity) {
                final CartViewModel cartViewModel = context.read<CartViewModel>();

                itemViewModel.setQuantity(newQuantity);
                cartViewModel.addOrUpdateToCart(itemViewModel);
              },
            )
          ],
        ),
      ],
    );
  }
}
