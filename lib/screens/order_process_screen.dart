import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../constants/animations.dart';
import '../constants/images.dart';
import '../models/merchant.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/fade_translate_animation.dart';

class OrderProcessScreen extends StatefulWidget {
  @override
  _OrderProcessScreenState createState() => _OrderProcessScreenState();
}

class _OrderProcessScreenState extends State<OrderProcessScreen> with TickerProviderStateMixin {
  AnimationController _smileyAnimationController;
  Animation<double> _smileyOpacityAnimation;

  AnimationController _orderStateAnimationController;
  Animation<double> _orderStateOpacityAnimation;

  bool _isOrderPlaced = false;

  @override
  void initState() {
    super.initState();

    _smileyAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _smileyOpacityAnimation = Tween(
      begin: 1.0,
      end: 0.2,
    ).animate(_smileyAnimationController);

    _orderStateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _orderStateOpacityAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_orderStateAnimationController);

    _smileyAnimationController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), () {
      // If widget is still mounted, then do animation
      if (mounted) {
        _orderStateAnimationController.forward().whenComplete(() {
          if (mounted) {
            setState(() => _isOrderPlaced = true);
            _orderStateAnimationController.reverse();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _smileyAnimationController.dispose();
    _orderStateAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartViewModel cartViewModel = context.watch<CartViewModel>();
    final Merchant merchant = cartViewModel.merchant;

    return Material(
      color: Color(merchant.backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: FadeTransition(
          opacity: _orderStateOpacityAnimation,
          child: !_isOrderPlaced ? _buildLoadingState() : _buildSuccessState(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: _buildLoader(),
        ),
        SizedBox(height: 24.0),
        _buildInfoText(
          title: 'Sit tight...',
          message: "We're placing your order",
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCheckmark(),
        SizedBox(height: 24.0),
        _buildInfoText(
          title: 'Order placed successfully!',
          message: "You will recieve your tasty food\n in 10 - 15 mins",
          curve: Curves.easeInBack,
        )
      ],
    );
  }

  Widget _buildLoader() {
    final CartViewModel cartViewModel = context.watch<CartViewModel>();
    final Merchant merchant = cartViewModel.merchant;

    return Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          strokeWidth: 3.5,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(
            Color(merchant.backgroundColor).withOpacity(0.8),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: _smileyOpacityAnimation,
            child: Image.asset(
              Images.SMILEY,
              height: 48,
              width: 48,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckmark() {
    final CartViewModel cartViewModel = context.watch<CartViewModel>();
    final Merchant merchant = cartViewModel.merchant;

    return Transform.scale(
      scale: 2.2,
      child: Lottie.asset(
        LottieAnimations.CHECKMARK,
        height: 100,
        width: 100,
        repeat: false,
        delegates: LottieDelegates(
          values: [
            // TODO: Didn't change the color of the 'check'
            ValueDelegate.color(
              const ['check', '**'],
              value: Color(merchant.backgroundColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText({@required String title, @required String message, Curve curve = Curves.easeIn}) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return FadeTranslateAnimation(
      key: ValueKey(title),
      curve: curve,
      duration: const Duration(milliseconds: 300),
      offset: Offset(0, -50),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.subtitle1.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 9.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
