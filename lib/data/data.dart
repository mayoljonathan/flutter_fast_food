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
    ItemCategory(
      name: 'Breakfast',
      imageUrl: 'assets/images/breakfast1.png',
      items: [
        Item(
          id: 'a1',
          imageUrl: 'assets/images/breakfast1.png',
          name: '1-pc. Mushroom Pepper Steak w/ Garlic Rice, Hash Browns & Egg Bowl',
          description: '',
          ingredients: [],
          price: 138,
        ),
        Item(
          id: 'a2',
          imageUrl: 'assets/images/breakfast2.png',
          name: 'Longganisa w/ Egg & Hash Browns Rice Bowl',
          description: null,
          ingredients: [],
          price: 154,
        ),
        Item(
          id: 'a3',
          imageUrl: 'assets/images/breakfast3.png',
          name: 'Spicy Chicken McDo & Hotcakes w/ Hash Browns',
          description: null,
          ingredients: [],
          price: 179,
        ),
        Item(
          id: 'a4',
          imageUrl: 'assets/images/breakfast4.png',
          name: 'Big Breakfast',
          description: null,
          ingredients: [],
          price: 157,
        ),
      ],
    ),
    ItemCategory(
      name: 'Burgers',
      imageUrl: 'assets/images/burger1.png',
      items: [
        Item(
          id: 'b1',
          imageUrl: 'assets/images/burger1.png',
          name: 'Big Mac',
          description:
              'A big and tasty Halal beef patty smothered in our one of a kind Big Tasty Sauce and 3 slices of emmental cheese',
          ingredients: [
            Ingredient(name: 'Big Bun', imageUrl: 'assets/images/ingredient1.png'),
            Ingredient(name: 'Beef Patty', imageUrl: 'assets/images/ingredient2.png'),
            Ingredient(name: 'Lettuce', imageUrl: 'assets/images/ingredient3.png'),
            Ingredient(name: 'Pickles', imageUrl: 'assets/images/ingredient4.png'),
            Ingredient(name: 'Cheese', imageUrl: 'assets/images/ingredient5.png'),
          ],
          price: 149,
        ),
        Item(
          id: 'b2',
          imageUrl: 'assets/images/burger2.png',
          name: 'Cheeseburger Deluxe',
          description:
              'Your favorite cheeseburger is now made deluxe! The same juicy beef patty covered with a slice of cheese and ketchup, mustard, mayonnaise, fresh onions and pickles all wrapped in a fresh bun but with an extra slice of tomato and crunchy lettuce.',
          ingredients: [
            Ingredient(name: 'Big Bun', imageUrl: 'assets/images/ingredient1.png'),
            Ingredient(name: 'Beef Patty', imageUrl: 'assets/images/ingredient2.png'),
            Ingredient(name: 'Lettuce', imageUrl: 'assets/images/ingredient3.png'),
            Ingredient(name: 'Pickles', imageUrl: 'assets/images/ingredient4.png'),
            Ingredient(name: 'Cheese', imageUrl: 'assets/images/ingredient5.png'),
            Ingredient(name: 'Tomato', imageUrl: 'assets/images/ingredient6.png'),
          ],
          price: 93,
        ),
        Item(
          id: 'b3',
          imageUrl: 'assets/images/burger3.png',
          name: 'Double Quarter Pounder w/ Cheese',
          description: null,
          ingredients: [
            Ingredient(name: 'Big Bun', imageUrl: 'assets/images/ingredient1.png'),
            Ingredient(name: 'Beef Patty', imageUrl: 'assets/images/ingredient2.png'),
            Ingredient(name: 'Pickles', imageUrl: 'assets/images/ingredient4.png'),
            Ingredient(name: 'Cheese', imageUrl: 'assets/images/ingredient5.png'),
            Ingredient(name: 'Tomato', imageUrl: 'assets/images/ingredient6.png'),
          ],
          price: 225,
        ),
      ],
    ),
    ItemCategory(name: 'Value Meals', imageUrl: 'assets/images/value_meal1.png', items: []),
    ItemCategory(name: 'Snack & Sides', imageUrl: 'assets/images/snacks1.png', items: []),
    ItemCategory(name: 'Deserts', imageUrl: 'assets/images/desert1.png', items: [
      Item(
        id: 'desert1',
        imageUrl: 'assets/images/desert1.png',
        name: 'McFlurry with Oreo',
        description: null,
        ingredients: [],
        price: 49,
      ),
    ]),
    ItemCategory(name: 'Beverages', imageUrl: 'assets/images/drink1.png', items: [
      Item(
        id: 'drink1',
        imageUrl: 'assets/images/drink1.png',
        name: 'Coke McFloat',
        description: null,
        ingredients: [],
        price: 45,
      ),
      Item(
        id: 'sprite1',
        imageUrl: 'assets/images/sprite.png',
        name: 'Sprite',
        description: null,
        ingredients: [],
        price: 35,
      ),
    ]),
  ];
  static List<ItemCategory> get itemCategories => _itemCategories;
}
