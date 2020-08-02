import 'package:flutter/foundation.dart';

import '../models/merchant.dart';
import 'item_viewmodel.dart';

class CartViewModel extends ChangeNotifier {
  Merchant _merchant;
  Merchant get merchant => _merchant;
  void setMerchant(Merchant merchant) {
    _merchant = merchant;
  }

  bool get isEmpty => _totalQuantity == 0;

  int _totalQuantity = 0;
  int get totalQuantity => _totalQuantity;

  double _totalPrice = 0;
  double get totalPrice => _totalPrice;

  List<ItemViewModel> _cartItems = [];
  List<ItemViewModel> get cartItems => _cartItems;

  /// Returns an ItemViewModel from the cart
  ItemViewModel getItemInCart(ItemViewModel itemModel) {
    return _cartItems.firstWhere(
      (cartItemModel) => cartItemModel.item.hashCode == itemModel.item.hashCode,
      orElse: () => null,
    );
  }

  void addOrUpdateToCart(ItemViewModel itemModel) async {
    ItemViewModel currentItem = getItemInCart(itemModel);
    if (currentItem == null) {
      _addToCart(itemModel);
    } else {
      if (itemModel.quantity == 0) {
        _removeFromCart(itemModel);
      }
      // Update quantity of the item
      currentItem.setQuantity(itemModel.quantity);
    }

    _totalQuantity = _getTotalQuantityInCart();
    _totalPrice = _getTotalPriceInCart();

    notifyListeners();
  }

  void _addToCart(ItemViewModel itemModel) {
    _cartItems.insert(_cartItems.length, itemModel);
  }

  void _removeFromCart(ItemViewModel itemModel) {
    _cartItems.removeWhere((ItemViewModel cartItemModel) => cartItemModel.item.hashCode == itemModel.item.hashCode);
  }

  // Gets total number of quantity per each item in cart
  // ex. Item A - 2pcs (Price 150 each)
  //     Item B - 1pc (Price 100 each)
  //    -------------
  //     Total is 3
  int _getTotalQuantityInCart() => _cartItems.fold(0, (int sum, ItemViewModel model) => sum + model.quantity);

  // Gets total price per each item in cart
  // ex. Item A - 2pcs (Price 150 each) (150 x 2)
  //     Item B - 1pc (Price 100 each) (100 x 1)
  //    -------------
  //     Total price is (400)
  double _getTotalPriceInCart() {
    double total = 0;
    if (_cartItems.isNotEmpty) {
      total = _cartItems.fold(0, (double sum, model) => sum + (model.item.price * model.quantity));
    }
    return total;
  }
}
