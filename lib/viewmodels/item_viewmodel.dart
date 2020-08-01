import 'package:flutter/foundation.dart';

import '../models/item.dart';

class ItemViewModel extends ChangeNotifier {
  final Item item;
  int quantity;

  ItemViewModel({
    @required this.item,
    this.quantity = 0,
  });

  double get totalPrice => quantity * item.price;

  void setQuantity(int newQuantity) {
    quantity = newQuantity;
    notifyListeners();
  }
}
