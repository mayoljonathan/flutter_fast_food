import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../models/item.dart';
import '../widgets/awesome_button.dart';
import '../widgets/fade_translate_animation.dart';
import '../widgets/modal_handle_indicator.dart';
import '../widgets/quantity_picker.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({
    Key key,
    @required this.item,
    this.initialQuantity = 0,
  }) : super(key: key);

  final Item item;
  final int initialQuantity;

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final Duration _animationDuration = const Duration(milliseconds: 500);
  final double _bottomBarHeight = kToolbarHeight + 24.0;

  int _tempQuantity;

  bool get _isInCart => widget.initialQuantity > 0;
  double get _totalPrice => _tempQuantity * widget.item.price;

  @override
  void initState() {
    super.initState();

    _tempQuantity = _isInCart ? widget.initialQuantity : 1;
  }

  String get buttonText {
    if (_tempQuantity == 0) return 'Back to Menu';
    if (_isInCart) return 'Update Cart – PHP $_totalPrice';
    return 'Add to Cart – PHP $_totalPrice';
  }

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
              SizedBox(height: _bottomBarHeight),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: _bottomBarHeight,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: FadeTranslateAnimation(
                  duration: _animationDuration,
                  child: Image.asset(
                    widget.item.imageUrl,
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              Text(
                widget.item.name,
                textAlign: TextAlign.center,
                style: textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3.0),
              Text(
                'PHP ${widget.item.price}',
                style: textTheme.subtitle1.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (widget.item.hasDescription)
          Padding(
            padding: const EdgeInsets.only(
              top: 24.0,
              left: 24.0,
              right: 24.0,
            ),
            child: Text(
              widget.item.description,
              textAlign: TextAlign.center,
              style: textTheme.bodyText2.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        if (widget.item.hasIngredients)
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
                  itemCount: widget.item.ingredients.length,
                  itemBuilder: (_, int i) => _buildIngredientItem(widget.item.ingredients[i]),
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
              child: ingredient?.imageUrl != null
                  ? Image.asset(
                      ingredient.imageUrl,
                      height: 48,
                      width: 48,
                    )
                  : SizedBox(
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
              child: QuantityPicker(
                key: ObjectKey(widget.item),
                value: _tempQuantity,
                onChanged: (int newQuantity) => setState(() => _tempQuantity = newQuantity),
              ),
            ),
            SizedBox(width: 18.0),
            Expanded(
              child: AwesomeButton(
                onPressed: () => Navigator.pop(context, _tempQuantity),
                text: buttonText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
