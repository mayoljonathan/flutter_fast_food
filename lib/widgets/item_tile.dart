import 'package:flutter/material.dart';

import '../models/item.dart';
import 'quantity_picker.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key key,
    @required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
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
              value: 0,
            )
          ],
        ),
      ],
    );
  }
}
