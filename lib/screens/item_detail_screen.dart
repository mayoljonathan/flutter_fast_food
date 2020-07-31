import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../models/item.dart';
import '../widgets/awesome_button.dart';
import '../widgets/fade_translate_animation.dart';
import '../widgets/modal_handle_indicator.dart';
import '../widgets/quantity_picker.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({
    Key key,
    @required this.item,
  });

  final Item item;

  final Duration _animationDuration = const Duration(milliseconds: 500);
  final double _bottomBarHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: _buildItemInfo(context),
              ),
              SizedBox(height: _bottomBarHeight + 24.0),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: _bottomBarHeight + 24.0,
          child: _buildBottomBar(context),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: ModalHandleIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemInfo(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              FadeTranslateAnimation(
                duration: _animationDuration,
                child: Image.asset(
                  item.imageUrl,
                  height: 150,
                  width: 150,
                ),
              ),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3.0),
              Text(
                'PHP ${item.price}',
                style: textTheme.subtitle1.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (item.hasDescription)
          Padding(
            padding: const EdgeInsets.only(
              top: 24.0,
              left: 24.0,
              right: 24.0,
            ),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: textTheme.bodyText2.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        if (item.hasIngredients)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 120,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: item.ingredients.length,
                  itemBuilder: (_, int i) => _buildIngredientItem(item.ingredients[i]),
                  separatorBuilder: (_, __) => SizedBox(width: 12.0),
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildIngredientItem(Ingredient ingredient) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 80,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: FadeTranslateAnimation(
              duration: _animationDuration,
              child: Image.asset(
                ingredient.imageUrl,
                height: 48,
                width: 48,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                ingredient.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 1),
          end: Alignment(0, -1),
          colors: [
            Colors.white70,
            Colors.white10,
          ],
          stops: [
            0.5,
            0.8,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            SizedBox(
              height: 48,
              child: QuantityPicker(),
            ),
            SizedBox(width: 18.0),
            Expanded(
              child: AwesomeButton(
                onPressed: () => Navigator.pop(context),
                text: 'Add to cart',
              ),
            )
          ],
        ),
      ),
    );
  }
}
