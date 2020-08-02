import 'package:flutter/cupertino.dart';

class MerchantDetailViewModel extends ChangeNotifier {
  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  set selectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }
}
