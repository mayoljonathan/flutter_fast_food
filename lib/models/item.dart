import 'package:flutter/foundation.dart';

class Item {
  String id;
  String name;
  String imageUrl;
  double price;

  Item({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.price,
  });
}
