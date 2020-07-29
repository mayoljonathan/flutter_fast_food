import 'package:flutter/material.dart';

class FadeTranslateAnimation extends StatefulWidget {
  const FadeTranslateAnimation(
      {Key key,
      this.controller,
      this.animation,
      @required this.child,
      this.duration = const Duration(milliseconds: 250),
      this.curve = Curves.fastOutSlowIn,
      this.animateDelay = const Duration(milliseconds: 0),
      this.offset = const Offset(0, -30),
      this.onCreate})
      : super(key: key);

  final AnimationController controller;
  final Animation<double> animation;
  final Widget child;

  /// Default of [250 milliseconds]
  final Duration duration;

  /// Default to [Curves.fastOutSlowIn]
  final Curve curve;

  /// Delay for the animation to start
  final Duration animateDelay;

  /// Child's origin offset until it goes to Offset(0, 0)
  final Offset offset;

  // Exposes animationController for this widget
  final void Function(AnimationController) onCreate;

  @override
  _FadeTranslateAnimationState createState() => _FadeTranslateAnimationState();
}

class _FadeTranslateAnimationState extends State<FadeTranslateAnimation> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  double _dx;
  double _dy;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _animationController = AnimationController(
        vsync: this,
        duration: widget.duration,
      )..addListener(() {
          if (!mounted) return;
          setState(() {});
        });
    } else
      _animationController = widget.controller;

    if (widget.animation == null) {
      _animation = CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
      );
    } else
      _animation = widget.animation;

    Future.delayed(widget.animateDelay, () {
      if (!mounted) return;
      _animationController.forward();
    });

    // Expose controller
    if (widget.onCreate != null) widget?.onCreate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dx = -((widget.offset.dx * _animation.value) - widget.offset.dx);
    _dy = (widget.offset.dy * _animation.value) - widget.offset.dy;

    return FadeTransition(
      opacity: _animation,
      child: Transform.translate(
        offset: Offset(_dx, _dy),
        child: widget.child,
      ),
    );
  }
}
