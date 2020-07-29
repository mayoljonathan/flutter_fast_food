import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../data/data.dart';
import '../models/item_category.dart';
import '../models/merchant.dart';
import '../widgets/fade_translate_animation.dart';
import '../widgets/item_category_list.dart';
import '../widgets/item_grid.dart';
import '../widgets/merchant_info.dart';

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

  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
    MediaQueryData mqd = MediaQuery.of(context);

    return Material(
      child: Stack(
        children: [
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: mqd.viewPadding.top),
                  child: _buildHero(),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (_, __) => SliverPadding(
                  padding: EdgeInsets.only(top: _topSpacerTween.value),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  child: PreferredSize(
                    preferredSize: Size.fromHeight(160),
                    child: _buildStickyHeader(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Material(
                  color: Colors.white,
                  child: FadeTranslateAnimation(
                    offset: Offset(0, -mqd.size.height),
                    child: ItemCategoryList(
                      categories: Data.itemCategories,
                      onSelected: (ItemCategory selected) {
                        print(selected.name);
                      },
                    ),
                  ),
                ),
              ),
              for (final itemCategory in Data.itemCategories)
                if (itemCategory.items.length > 0)
                  SliverToBoxAdapter(
                    child: Material(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                        child: FadeTranslateAnimation(
                          offset: Offset(0, -mqd.size.height),
                          child: ItemGrid(itemCategory: itemCategory),
                        ),
                      ),
                    ),
                  ),

              // Spacer to the bottom
              SliverPadding(
                padding: EdgeInsets.only(bottom: mqd.viewPadding.top),
              )
            ],
          ),
          _buildAppBar(),
        ],
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({@required this.child});
  final PreferredSize child;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
