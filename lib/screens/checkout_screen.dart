import 'dart:math';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fast_food/widgets/fade_translate_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/images.dart';
import '../data/data.dart';
import '../models/item.dart';
import '../models/item_category.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/item_viewmodel.dart';
import '../widgets/awesome_button.dart';
import '../widgets/item_list.dart';
import '../widgets/item_tile.dart';
import 'item_detail_screen.dart';
import 'order_process_screen.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ItemCategory _suggestedItems = ItemCategory(
    imageUrl: null,
    name: 'You might like',
    items: [
      Item(
        id: 'ice_tea1',
        imageUrl: 'assets/images/ice_tea.png',
        name: 'Ice Tea',
        price: 35,
        description:
            "Ice tea is sweetened just right and shaken with ice. It's the ideal iced tea—a rich and flavorful tea journey awaits you.",
        ingredients: null,
      ),
      Item(
        id: 'sprite1',
        imageUrl: 'assets/images/sprite.png',
        name: 'Sprite',
        price: 35,
        description:
            'A lemon-lime flavored soft drink with a crisp, clean taste that gives you the ultimate cut-through refreshment.',
        ingredients: null,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();

    // Get random items from a random itemCategory
    _suggestedItems.items.insertAll(0, _getRandomItems(3));
  }

  List<Item> _getRandomItems(int randomItemCount) {
    final validItemCategories = Data.itemCategories
        .where((ItemCategory itemCategory) => itemCategory.items != null && itemCategory.items.length > 0)
        .toList();

    List<Item> items = [];

    for (var i = 0; i < randomItemCount; i++) {
      final random = Random();

      // Random itemCategory
      final itemCategory = validItemCategories[random.nextInt(validItemCategories.length)];
      final Item item = itemCategory.items[random.nextInt(itemCategory.items.length)];

      items.add(item);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(EvaIcons.arrowBackOutline),
          onPressed: () => Navigator.pop(context),
        ),
        title: Selector<CartViewModel, String>(
          selector: (_, model) => model.merchant.name,
          builder: (_, String name, __) => Text(
            name ?? '',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
      body: Selector<CartViewModel, bool>(
        selector: (_, model) => model.isEmpty,
        builder: (_, bool isEmpty, Widget child) => isEmpty ? _buildEmptyCartState() : child,
        child: _buildLoadedCartState(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Selector<CartViewModel, bool>(
        selector: (_, model) => model.isEmpty,
        shouldRebuild: (_, __) => false,
        builder: (_, bool isEmpty, Widget child) => isEmpty ? SizedBox() : child,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity,
            child: Selector<CartViewModel, double>(
              selector: (_, model) => model.totalPrice,
              builder: (_, double totalPrice, __) => AwesomeButton(
                tag: 'cta',
                text: 'Pay PHP ${totalPrice.toString()}',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderProcessScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCartState() {
    return Center(
      child: Text('No items in your order.'),
    );
  }

  Widget _buildLoadedCartState() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildSection(
              title: Text('Your order'),
              child: Selector<CartViewModel, List<ItemViewModel>>(
                selector: (_, model) => model.cartItems,
                builder: (_, List<ItemViewModel> cartItems, __) => Column(
                  children: [for (final itemViewModel in cartItems) _buildCartItem(itemViewModel)],
                ),
              ),
            ),
          ),
          _buildSection(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('You might like'),
            ),
            child: FadeTranslateAnimation(
              offset: Offset(30, 0),
              child: ItemList(
                itemCategory: _suggestedItems,
                showHeader: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildSection(
              title: Text('Total'),
              child: _buildSummary(),
            ),
          ),
          _buildSection(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
              child: Text('Pay with'),
            ),
            child: _buildPayOption(),
          ),
          SizedBox(height: 80.0),
        ],
      ),
    );
  }

  Widget _buildCartItem(ItemViewModel itemViewModel) {
    final MediaQueryData mqd = MediaQuery.of(context);

    return ChangeNotifierProvider<ItemViewModel>.value(
      value: itemViewModel,
      builder: (BuildContext context, __) => Selector<ItemViewModel, int>(
        selector: (_, model) => model.quantity,
        builder: (_, int quantity, __) => InkWell(
          borderRadius: BorderRadius.circular(6.0),
          child: ItemTile(
            layout: ItemTileLayout.layout2,
            shouldCalculatePrice: true,
          ),
          onTap: () async {
            int updatedQuantity = await showModalBottomSheet<int>(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              builder: (_) => ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: mqd.size.height - mqd.viewPadding.top,
                ),
                child: ItemDetailScreen(
                  item: itemViewModel.item,
                  initialQuantity: quantity,
                ),
              ),
            );

            if (updatedQuantity != null) {
              itemViewModel.setQuantity(updatedQuantity);
              context.read<CartViewModel>().addOrUpdateToCart(itemViewModel);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    @required Widget title,
    @required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
          child: title,
        ),
        SizedBox(height: 12.0),
        child,
      ],
    );
  }

  Widget _buildSummary() {
    final CartViewModel cartViewModel = context.watch<CartViewModel>();

    return Column(
      children: [
        _buildSummaryItem(
          title: 'Subtotal',
          value: cartViewModel.totalPrice.toString(),
        ),
        _buildSummaryItem(
          title: 'Delivery Fee (Free)',
          value: '0',
          textColor: Colors.green,
        ),
        SizedBox(height: 9.0),
        _buildSummaryItem(
          title: 'TOTAL',
          value: cartViewModel.totalPrice.toString(),
          titleStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSummaryItem({@required String title, @required String value, TextStyle titleStyle, Color textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
            ).merge(titleStyle),
          ),
          Spacer(),
          Text(
            'PHP $value',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayOption() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
        child: Row(
          children: [
            Container(
              child: Image.asset(
                Images.APPLE_PAY,
                height: 36,
                width: 36,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Apple Pay'),
              ),
            ),
            Icon(
              EvaIcons.chevronRightOutline,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
