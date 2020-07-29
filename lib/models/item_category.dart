import 'package:flutter/foundation.dart';

import 'item.dart';

class ItemCategory {
  String name;
  String imageUrl;
  List<Item> items;

  ItemCategory({
    @required this.name,
    @required this.imageUrl,
    @required this.items,
  });
}
