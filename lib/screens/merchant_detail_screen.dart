import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/data.dart';
import '../models/item_category.dart';
import '../models/merchant.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/merchant_detail_viewmodel.dart';
import '../widgets/awesome_button.dart';
import '../widgets/fade_translate_animation.dart';
import '../widgets/item_category_list.dart';
import '../widgets/item_list.dart';
import '../widgets/merchant_info.dart';
import 'checkout_screen.dart';

class MerchantDetailScreen extends StatefulWidget {
  const MerchantDetailScreen({
    Key key,
    @required this.merchant,
  });

  final Merchant merchant;

  @override
  _MerchantDetailScreenState createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  AnimationController _animationController;
  Animation<double> _heroOpacityTween;
  Animation<Color> _bgColorTween;
  Animation<Color> _iconColorTween;
  Animation<num> _merchantInfoBorderRadiusTween;

  Animation<num> _topSpacerTween;

  final double _merchantInfoBorderRadius = 20.0;

  // Threshold when hero will no longer show
  final double _collapseThreshold = 150;
  final double _bottomBarHeight = kToolbarHeight + 24.0;

  @override
  void initState() {
    super.initState();
    Provider.of<CartViewModel>(context, listen: false).setMerchant(widget.merchant);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(),
    );

    _heroOpacityTween = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_animationController);

    _iconColorTween = ColorTween(
      begin: Colors.white,
      end: Colors.black87,
    ).animate(_animationController);

    _bgColorTween = ColorTween(
      begin: Color(widget.merchant.backgroundColor),
      end: Colors.white,
    ).animate(_animationController);

    _merchantInfoBorderRadiusTween = Tween(
      begin: _merchantInfoBorderRadius,
      end: 0.0,
    ).animate(_animationController);

    _topSpacerTween = Tween(
      begin: 0.0,
      end: 24.0,
    ).animate(_animationController);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      _animationController.animateTo(_scrollController.offset / _collapseThreshold);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mqd = MediaQuery.of(context);

    return ChangeNotifierProvider(
      create: (_) => MerchantDetailViewModel(),
      builder: (BuildContext context, __) => Material(
        child: Stack(
          children: [
            // Merchant's background color
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) => Container(
                color: _bgColorTween.value,
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              slivers: [
                // Container to the device status bar since it shows the main body overlapping
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    child: PreferredSize(
                      preferredSize: Size.fromHeight(mqd.viewPadding.top == 0 ? 24.0 : mqd.viewPadding.top),
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (_, __) => Container(
                          height: mqd.viewPadding.top == 0 ? 24.0 : mqd.viewPadding.top,
                          color: _bgColorTween.value == Colors.white ? Colors.white : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                // Merchant's hero image!
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: mqd.viewPadding.top),
                    child: _buildHero(),
                  ),
                ),
                // Give a Hero a floating effect when scrolled!
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) => SliverPadding(
                    padding: EdgeInsets.only(top: _topSpacerTween.value),
                  ),
                ),
                // Merchant's info sticky header
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    child: PreferredSize(
                      preferredSize: Size.fromHeight(160),
                      child: _buildStickyHeader(),
                    ),
                  ),
                ),
                // Item's category list
                SliverToBoxAdapter(
                  child: Material(
                    color: Colors.white,
                    child: FadeTranslateAnimation(
                      offset: Offset(0, -mqd.size.height),
                      child: Center(
                        child: Selector<MerchantDetailViewModel, int>(
                          selector: (_, model) => model.selectedCategoryIndex,
                          builder: (_, int index, __) => ItemCategoryList(
                            initialIndex: index,
                            categories: Data.itemCategories,
                            selectedColor: Color(widget.merchant.backgroundColor),
                            onSelected: (ItemCategory selected) {
                              final merchantDetailViewModel = context.read<MerchantDetailViewModel>();
                              merchantDetailViewModel.selectedCategoryIndex = Data.itemCategories.indexOf(selected);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Items grid for each item categories
                for (final itemCategory in Data.itemCategories)
                  if (itemCategory.items.length > 0)
                    SliverToBoxAdapter(
                      child: Material(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                          child: FadeTranslateAnimation(
                            offset: Offset(0, -mqd.size.height),
                            child: ItemList(
                              itemCategory: itemCategory,
                              layout: ItemListLayout.grid,
                            ),
                          ),
                        ),
                      ),
                    ),

                // Spacer for the bottom bar
                SliverPadding(
                  padding: EdgeInsets.only(bottom: _bottomBarHeight),
                ),
              ],
            ),
            _buildAppBar(),
            // Bottom Bar
            Selector<CartViewModel, bool>(
              selector: (_, CartViewModel model) => model.isEmpty,
              builder: (_, bool isEmpty, Widget child) => AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                bottom: !isEmpty ? 0 : -_bottomBarHeight,
                left: 0,
                right: 0,
                height: _bottomBarHeight,
                child: _buildBottomBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 12.0),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, __) => IconTheme(
              data: IconThemeData(
                color: _iconColorTween.value,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeTranslateAnimation(
                    animateDelay: const Duration(milliseconds: 100),
                    offset: Offset(-9, 0),
                    child: IconButton(
                      icon: Icon(EvaIcons.arrowBackOutline),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  IconButton(
                    icon: Icon(EvaIcons.searchOutline),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: 'merchant-hero-${widget.merchant.hashCode}',
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, Widget child) => Opacity(
              opacity: _heroOpacityTween.value,
              child: child,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Image.asset(
                widget.merchant.imageUrl,
                height: 180,
                width: 180,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildStickyHeader() {
    return Stack(
      children: [
        Hero(
          tag: 'merchant-card-${widget.merchant.hashCode}',
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_merchantInfoBorderRadius),
                topRight: Radius.circular(_merchantInfoBorderRadius),
              ),
              color: Colors.white,
            ),
          ),
        ),
        FadeTranslateAnimation(
          animateDelay: const Duration(milliseconds: 100),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, Widget child) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_merchantInfoBorderRadiusTween.value),
                  topRight: Radius.circular(_merchantInfoBorderRadiusTween.value),
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: child,
            ),
            child: MerchantInfo(
              tag: 'merchant-info-${widget.merchant.hashCode}',
              merchant: widget.merchant,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBottomBar() {
    final TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold);

    return SafeArea(
      top: false,
      bottom: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0, -1),
            end: Alignment(0, 1),
            colors: [
              Colors.white10,
              Colors.white24,
              Colors.white,
            ],
            stops: [
              0.01,
              0.05,
              0.2,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Selector<CartViewModel, int>(
                  selector: (_, model) => model.totalQuantity,
                  builder: (_, int totalQuantity, __) => AnimatedSize(
                    vsync: this,
                    duration: const Duration(milliseconds: 200),
                    child: FadeTranslateAnimation(
                      key: UniqueKey(), // Give it an awesome unique key so animation triggers every build
                      offset: Offset(0, -10),
                      child: Text(
                        totalQuantity.toString(),
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Selector<CartViewModel, double>(
                    selector: (_, model) => model.totalPrice,
                    builder: (_, double totalPrice, __) => FadeTranslateAnimation(
                      key: UniqueKey(), // Give it an awesome unique key so animation triggers every build
                      offset: Offset(0, -10),
                      child: Text(
                        'PHP ${totalPrice.toString()}',
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AwesomeButton(
                  tag: 'cta',
                  text: 'View cart',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutScreen(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({@required this.child});
  final PreferredSize child;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
