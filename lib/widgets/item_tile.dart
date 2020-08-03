import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
import 'quantity_picker.dart';

enum ItemTileLayout {
  layout1,
  layout2,
  layout3,
}

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key key,
    this.layout = ItemTileLayout.layout1,
    this.shouldCalculatePrice = false,
  }) : super(key: key);

  final ItemTileLayout layout;

  // Defaults to false, set to true if you want the price multiplied by quantity
  final bool shouldCalculatePrice;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox();

    switch (layout) {
      case ItemTileLayout.layout1:
        child = _buildLayout1(context);
        break;
      case ItemTileLayout.layout2:
        child = _buildLayout2(context);
        break;
      case ItemTileLayout.layout3:
        child = _buildLayout3(context);
        break;
    }

    if (kIsWeb) {
      return HoverCursor(
        cursor: Cursor.pointer,
        child: child,
      );
    }

    return child;
  }

  Widget _buildLayout1(BuildContext context) {
    final ItemViewModel itemViewModel = context.watch<ItemViewModel>();
    final Item item = itemViewModel.item;

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
                  height: 100,
                  width: 100,
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
          child: Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPrice(!shouldCalculatePrice ? item.price.toString() : itemViewModel.totalPrice.toString()),
            _buildQuantityPicker(
              context: context,
              itemViewModel: itemViewModel,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLayout2(BuildContext context) {
    final ItemViewModel itemViewModel = context.watch<ItemViewModel>();
    final Item item = itemViewModel.item;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.asset(
              item.imageUrl,
              height: 40,
              width: 40,
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name),
                SizedBox(height: 9.0),
                _buildPrice(!shouldCalculatePrice ? item.price.toString() : itemViewModel.totalPrice.toString()),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: _buildQuantityPicker(
              context: context,
              itemViewModel: itemViewModel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayout3(BuildContext context) {
    final ItemViewModel itemViewModel = context.watch<ItemViewModel>();
    final Item item = itemViewModel.item;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 12.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                item.imageUrl,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 9.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPrice(!shouldCalculatePrice ? item.price.toString() : itemViewModel.totalPrice.toString()),
                      _buildQuantityPicker(
                        context: context,
                        itemViewModel: itemViewModel,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrice(String priceAsText) {
    return Text(
      'PHP $priceAsText',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuantityPicker({
    @required BuildContext context,
    @required ItemViewModel itemViewModel,
  }) {
    return QuantityPicker(
      value: itemViewModel.quantity,
      onChanged: (int newQuantity) {
        final CartViewModel cartViewModel = context.read<CartViewModel>();

        itemViewModel.setQuantity(newQuantity);
        cartViewModel.addOrUpdateToCart(itemViewModel);
      },
    );
  }
}
