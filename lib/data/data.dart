import 'package:fast_food/models/ingredient.dart';
import 'package:fast_food/models/item.dart';
import 'package:fast_food/models/item_category.dart';

import '../constants/images.dart';
import '../models/merchant.dart';

class Data {
  static List<Merchant> _merchants = [
    Merchant(
      name: 'McDonald\'s',
      logoUrl: Images.MCDO,
      imageUrl: Images.MCDO_HERO,
      rating: 4.8,
      tags: ['Burgers', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFFFF5A3A,
      estimatedDelivery: '10 - 15 min',
    ),
    Merchant(
      name: 'Subway',
      logoUrl: Images.SUBWAY,
      imageUrl: Images.SUBWAY_HERO,
      rating: 4.8,
      tags: ['Sandwich', 'Healthy'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0BA218,
    ),
    Merchant(
      name: 'KFC',
      logoUrl: Images.KFC,
      imageUrl: Images.KFC_HERO,
      rating: 4.5,
      tags: ['Chicken', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFFFF5A3A,
      estimatedDelivery: '5 - 10 min',
    ),
    Merchant(
      name: 'Starbucks',
      logoUrl: Images.STARBUCKS,
      imageUrl: Images.STARBUCKS_HERO,
      rating: 4.5,
      tags: ['Coffee', 'Beverages'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF008780,
      estimatedDelivery: '10 - 15 min',
    ),
    Merchant(
      name: 'Domino\'s Pizza',
      logoUrl: Images.DOMINOS_PIZZA,
      imageUrl: Images.DOMINOS_PIZZA_HERO,
      rating: 4.5,
      tags: ['Pizza', 'Italian'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0082E8,
    ),
    Merchant(
      name: 'Shake Shack',
      logoUrl: Images.SHAKE_SHACK,
      imageUrl: Images.SHAKE_SHACK_HERO,
      rating: 4.5,
      tags: ['Burger', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0A090F,
      estimatedDelivery: '10 - 20 min',
    ),
  ];
  static List<Merchant> get merchants => _merchants;

  static List<ItemCategory> _itemCategories = [
    ItemCategory(name: 'Breakfast', imageUrl: Images.MCDO_HERO, items: [
      Item(
        id: 'a1',
        imageUrl: Images.KFC_HERO,
        name: 'Big Breakfast Meal',
        description: '',
        ingredients: [],
        price: 50,
      ),
      Item(
        id: 'a2',
        imageUrl: Images.KFC_HERO,
        name: 'Chicken Sausage',
        description: null,
        ingredients: [],
        price: 50,
      ),
      Item(
        id: 'a3',
        imageUrl: Images.KFC_HERO,
        name: 'Big Mac Burger',
        description:
            'A big and tasty Halal beef patty smothered in our one of a kind Big Tasty Sauce and 3 sliecs of emmental cheese',
        ingredients: [
          Ingredient(name: 'Big Bun', imageUrl: Images.SUBWAY_HERO),
          Ingredient(name: 'Beef Patty', imageUrl: Images.DOMINOS_PIZZA_HERO),
          Ingredient(name: 'Lettuce', imageUrl: Images.MCDO_HERO),
          Ingredient(name: 'Pickles', imageUrl: Images.STARBUCKS_HERO),
        ],
        price: 75,
      ),
      Item(
        id: 'a4',
        imageUrl: Images.KFC_HERO,
        name: 'Chicken Sausage',
        description: null,
        ingredients: [],
        price: 55,
      ),
    ]),
    ItemCategory(name: 'Burgers', imageUrl: Images.SUBWAY_HERO, items: []),
    ItemCategory(name: 'Value Meals', imageUrl: Images.KFC_HERO, items: []),
    ItemCategory(name: 'Snack & Sides', imageUrl: Images.SHAKE_SHACK_HERO, items: []),
    ItemCategory(name: 'Deserts', imageUrl: Images.DOMINOS_PIZZA_HERO, items: []),
    ItemCategory(name: 'Salads', imageUrl: Images.MCDO_HERO, items: []),
    ItemCategory(name: 'McCafe', imageUrl: Images.STARBUCKS_HERO, items: []),
  ];
  static List<ItemCategory> get itemCategories => _itemCategories;
}
