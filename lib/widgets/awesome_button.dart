import 'package:flutter/material.dart';

class AwesomeButton extends StatelessWidget {
  const AwesomeButton({
    Key key,
    this.tag,
    @required this.text,
    @required this.onPressed,
  });

  final String tag;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Widget child = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 48.0,
      ),
      child: RawMaterialButton(
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: StadiumBorder(),
        onPressed: onPressed,
        fillColor: Colors.black,
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        child: Text(
          text ?? '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (tag == null) return child;

    return Hero(
      tag: tag,
      child: child,
    );
  }
}
