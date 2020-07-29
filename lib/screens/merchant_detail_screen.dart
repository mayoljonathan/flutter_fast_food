import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../models/merchant.dart';
import '../widgets/fade_translate_animation.dart';
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
      begin: 24.0,
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
              // TODO: Item Grid
              SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        child: Placeholder(),
                      ),
                      Container(
                        height: 200,
                        child: Placeholder(),
                      ),
                      Container(
                        height: 200,
                        child: Placeholder(),
                      ),
                    ],
                  ),
                ),
              ),
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
                    offset: Offset(-24, 0),
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
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
              child: Image.asset(
                widget.merchant.imageUrl,
                height: 200,
                width: 200,
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              color: Colors.white,
            ),
          ),
        ),
        AnimatedBuilder(
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
