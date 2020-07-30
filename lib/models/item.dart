import 'package:fast_food/models/ingredient.dart';
import 'package:flutter/foundation.dart';

class Item {
  String id;
  String name;
  String description;
  List<Ingredient> ingredients;
  String imageUrl;
  double price;

  Item({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.ingredients,
    @required this.imageUrl,
    @required this.price,
  });

  bool get hasDescription => description != null && description.trim().length > 0;
  bool get hasIngredients => ingredients != null && ingredients.length > 0;
}
